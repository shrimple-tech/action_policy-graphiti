# frozen_string_literal: true

require "action_policy/graphiti/lookup_chain"

module ActionPolicy
  module Graphiti
    # Automatically authorize actions
    module Behaviour
      # Authorization configuration class methods
      # Meant to be used in Graphiti resources
      module ClassMethods
        AUTHORIZABLE_ACTIONS = %i[create update destroy].freeze
        IMPLICITLY_AUTHORIZABLE_ACTIONS = %i[index show].freeze

        def authorize_action(action, to: nil, with: nil, **arguments)
          if AUTHORIZABLE_ACTIONS.include?(action)
            callback_and_arguments = callback_and_arguments_for_action(action)

            callback = callback_and_arguments[:callback]
            callback_arguments = callback_and_arguments[:arguments]

            send(callback, **callback_arguments) do |model|
              rule = to || "#{action}?".to_sym

              policy = if with
                         with.is_a?(String) ? ActiveSupport::Inflector.safe_constantize(with) : with
                       else
                         ActionPolicy.lookup(self)
                       end

              authorize! model, with: policy, to: rule, **arguments
            end
          elsif IMPLICITLY_AUTHORIZABLE_ACTIONS.include?(action)
            raise ArgumentError, "Index and show authorization is done implicitly by scoping"
          else
            raise ArgumentError, "Unknown action cannot be authorized"
          end
        end

        def callback_and_arguments_for_action(action)
          if action == :destroy
            callback = :before_destroy
            arguments = {}
          else
            callback = :before_save
            arguments = { only: [action] }
          end

          {
            callback: callback,
            arguments: arguments
          }
        end

        def authorize_create(**arguments)
          authorize_action(:create, **arguments)
        end

        def authorize_update(**arguments)
          authorize_action(:update, **arguments)
        end

        def authorize_destroy(**arguments)
          authorize_action(:destroy, **arguments)
        end

        def authorize_scope(_scope_name = nil, with: nil)
          original_base_scope = instance_method(:base_scope)

          define_method(:base_scope) do |*args, &block|
            policy = if with
                       with.is_a?(String) ? ActiveSupport::Inflector.safe_constantize(with) : with
                     else
                       ActionPolicy.lookup(self)
                     end

            authorized_scope(
              original_base_scope.bind(self).call(*args, &block),
              with: policy
            )
          end
        end
      end

      def self.included(base)
        base.include(ActionPolicy::Behaviour)

        base.extend(ClassMethods)
      end
    end
  end
end
