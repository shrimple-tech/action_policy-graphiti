# frozen_string_literal: true

require "action_policy/graphiti/lookup_chain"

module ActionPolicy
  module Graphiti
    # Automatically authorize actions
    module AutomaticallyAuthorized
      include ActionPolicy::Behaviour

      # Authorization configuration class methods
      # Meant to be used in Graphiti resources
      module ClassMethods
        class << self
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
