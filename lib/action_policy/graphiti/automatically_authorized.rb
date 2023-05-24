# frozen_string_literal: true

require "action_policy/graphiti/lookup_chain"

module ActionPolicy
  module Graphiti
    # Automatically authorize actions
    module AutomaticallyAuthorized
      # Authorization configuration class methods
      # Meant to be used in Graphiti resources
      module ClassMethods
        def authorize_action(action)
          case action
          when :index
            raise NotImplementedError, "Index authorization is not yet implemented"
          when :show
            authorize_read
          when :create
            authorize_create
          when :update
            authorize_update
          when :destroy
            authorize_destroy
          else
            raise ArgumentError, "Unknown action cannot be authorized"
          end
        end

        def authorize_read
          after_attributes only: [:show] do |model|
            authorize! model, with: ActionPolicy.lookup(self), to: :show
          end
        end

        def authorize_create
          before_save only: [:create] do |model|
            authorize! model, with: ActionPolicy.lookup(self), to: :create
          end
        end

        def authorize_update
          before_save only: [:update] do |model|
            authorize! model, with: ActionPolicy.lookup(self), to: :update
          end
        end

        def authorize_destroy
          before_destroy do |model|
            authorize! model, with: ActionPolicy.lookup(self), to: :destroy
          end
        end
      end

      def current_user
        {}
      end

      def self.included(base)
        base.include(ActionPolicy::Behaviour)

        base.extend(ClassMethods)

        base.authorize :user, through: :current_user
      end
    end
  end
end
