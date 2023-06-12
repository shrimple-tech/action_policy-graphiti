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

        def authorize_action(action, **arguments)
          if AUTHORIZABLE_ACTIONS.include?(action)
            rule = "#{action}?".to_sym

            callback_and_arguments = callback_and_arguments_for_action(action)

            callback = callback_and_arguments[:callback]
            callback_arguments = callback_and_arguments[:arguments]

            send(callback, **callback_arguments) do |model|
              authorize! model, with: ActionPolicy.lookup(self), to: rule, **arguments
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

        def authorize_create
          authorize_action(:create)
        end

        def authorize_update
          authorize_action(:update)
        end

        def authorize_destroy
          authorize_action(:destroy)
        end

        def authorize_scope(_scope_name = nil)
          original_base_scope = instance_method(:base_scope)

          define_method(:base_scope) do |*args, &block|
            authorized_scope(
              original_base_scope.bind(self).call(*args, &block),
              with: ActionPolicy.lookup(self)
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
