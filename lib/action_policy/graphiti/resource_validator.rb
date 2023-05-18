# frozen_string_literal: true

module ActionPolicy
  module Graphiti
    # Validate Graphiti resources
    # Provides a few helpers mostly used in policy class lookups
    module ResourceValidator
      def self.graphiti_resource?(resource)
        resource_class = resource.is_a?(Class) ? resource : resource.class

        return unless resource_class.name.end_with?("Resource") &&
                      resource_class.ancestors.include?(::Graphiti::Resource)

        true
      end

      def self.polymorphic_graphiti_resource?(resource)
        resource_class = resource.is_a?(Class) ? resource : resource.class

        return unless resource_class.name.end_with?("Resource") &&
                      resource_class.ancestors.include?(::Graphiti::Resource::Polymorphism) &&
                      resource_class.ancestors.include?(::Graphiti::Resource)

        true
      end
    end
  end
end
