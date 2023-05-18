# frozen_string_literal: true

require "action_policy/graphiti/policy_name_inferrer"

module ActionPolicy
  # Allow policies to be found not only for ActiveRecords
  # but for Graphiti Resources (<EntityName>Resource) too
  module LookupChain
    INFER_FROM_RESOURCE_CLASS = lambda do |resource, namespace: nil, strict_namespace: false, **_options|
      policy_name = Graphiti::PolicyNameInferrer.infer(resource)
      lookup_within_namespace(policy_name, namespace, strict: strict_namespace)
    end

    INFER_FOR_BASE_FROM_POLYMORPHIC_RESOURCE_CLASS = lambda do |resource, namespace: nil, strict_namespace: false, **_options|
      policy_name = Graphiti::PolicyNameInferrer.infer_polymorphic(resource)
      lookup_within_namespace(policy_name, namespace, strict: strict_namespace)
    end

    chain << ActionPolicy::LookupChain::INFER_FROM_RESOURCE_CLASS
    chain << ActionPolicy::LookupChain::INFER_FOR_BASE_FROM_POLYMORPHIC_RESOURCE_CLASS
  end
end
