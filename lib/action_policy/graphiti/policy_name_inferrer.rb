# frozen_string_literal: true

require "action_policy/graphiti/resource_analyzer"

module ActionPolicy
  module Graphiti
    # Infer policy names for Graphiti resources
    module PolicyNameInferrer
      def self.infer(resource)
        model_name = ResourceAnalyzer.model_name(resource)

        "#{model_name}Policy" if model_name
      end

      def self.infer_polymorphic(resource)
        base_model_name = ResourceAnalyzer.base_model_name(resource)

        "#{base_model_name}Policy" if base_model_name
      end
    end
  end
end
