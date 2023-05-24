# frozen_string_literal: true

class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::Null

  def current_user
    context.current_user
  end

  def admin?
    current_user.admin?
  end
end

class TestModel
end

class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::AutomaticallyAuthorized

  self.model = TestModel

  authorize_action :create

  attribute :test_value, :integer
end

class ApplicationPolicy < ActionPolicy::Base
end

class TestPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    false
  end
end
