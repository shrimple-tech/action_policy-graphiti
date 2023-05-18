# frozen_string_literal: true

require "graphiti"
require "action_policy"

module ActionPolicy
  # Top-level module for ActionPolicy - Graphiti integration
  module Graphiti
    class << self
      # Which rule to use when no specified (e.g. `authorize: true`)
      # Defaults to `:show?`
      attr_accessor :default_authorize_rule
    end

    self.default_authorize_rule = :show?
  end
end
