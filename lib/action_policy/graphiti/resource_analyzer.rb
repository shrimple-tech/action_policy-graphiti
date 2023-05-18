# frozen_string_literal: true

require "action_policy/graphiti/resource_validator"

module ActionPolicy
  module Graphiti
    # A helper module used to get resource details
    module ResourceAnalyzer
      def self.resource_class(resource)
        return unless ResourceValidator.graphiti_resource?(resource)

        resource.is_a?(Class) ? resource : resource.class
      end

      def self.base_resource_class(polymorphic_resource)
        return unless ResourceValidator.polymorphic_graphiti_resource?(polymorphic_resource)

        resource_class = resource.is_a?(Class) ? resource : resource.class

        polymorphic_marker_index = resource_class.ancestors.find_index(::Graphiti::Resource::Polymorphism)

        resource_class.ancestors[polymorphic_marker_index + 1]
      end

      def self.model_name(resource)
        resource_class(resource)&.name&.delete_suffix("Resource")
      end

      def self.base_model_name(polymorphic_resource)
        base_resource_class(polymorphic_resource)&.name&.delete_suffix("Resource")
      end
    end
  end
end
