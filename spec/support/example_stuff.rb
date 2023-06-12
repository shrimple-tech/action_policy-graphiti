# frozen_string_literal: true

class User
  ATTRS = %i[id role].freeze
  ATTRS.each { |a| attr_accessor(a) }

  def initialize(attrs = {})
    attrs.each_pair { |k, v| send(:"#{k}=", v) }
  end

  def attributes
    {}.tap do |attrs|
      ATTRS.each do |name|
        attrs[name] = send(name)
      end
    end
  end

  def admin?
    role == "admin"
  end
end

class ApplicationResource < Graphiti::Resource
  include ActionPolicy::Graphiti::Behaviour

  self.abstract_class = true
  self.adapter = Graphiti::Adapters::Null

  authorize :user, through: :current_user
  authorize :arbitrary_parameter, through: :parameter

  def parameter
    5
  end

  def current_user
    raise NotImplementedError, "Use rspec mocks!"
  end

  def admin?
    current_user.admin?
  end
end

class TestModel
  ATTRS = %i[id title callback_marker].freeze
  ATTRS.each { |a| attr_accessor(a) }

  def initialize(attrs = {})
    attrs.each_pair { |k, v| send(:"#{k}=", v) }
  end

  def attributes
    {}.tap do |attrs|
      ATTRS.each do |name|
        attrs[name] = send(name)
      end
    end
  end
end

TEST_MODEL_DATA = [
  { id: 1, title: "TestRegularUserAccessible", callback_marker: nil },
  { id: 2, title: "TestAdminOnlyAccessible", callback_marker: nil }
]

class TestResource < ApplicationResource
  self.model = TestModel

  before_save only: [:update] do |model|
    model.callback_marker = true
  end

  authorize_action :create
  authorize_action :update
  authorize_action :destroy

  attribute :title, :string

  def base_scope
    TEST_MODEL_DATA.map { |d| TestModel.new(d) }
  end

  authorize_scope :test

  def resolve(scope)
    scope # Do nothing since we already have an array
  end

  # def build(model_class)
  #   model_class.new
  # end

  def assign_attributes(model, attributes)
    attributes.each_pair do |k, v|
      model.send(:"#{k}=", v)
    end
  end

  def save(model)
    attrs = model.attributes.dup
    attrs[:id] ||= TEST_MODEL_DATA.length + 1

    existing = TEST_MODEL_DATA.find { |d| d[:id].to_s == attrs[:id].to_s }

    if existing
      existing.merge!(attrs)
    else
      TEST_MODEL_DATA << attrs
    end

    model
  end

  def delete(model)
    # We don't delete data since we don't want other tests to fail

    model
  end
end

class ApplicationPolicy < ActionPolicy::Base
  authorize :arbitrary_parameter
end

class TestPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    false
  end

  def update?
    user.admin? && record.callback_marker && arbitrary_parameter
  end

  # Simulate a conflict between a rule and a scope, despite the action is allowed for regular users
  # They are prohibited from accessing even-numbered records by a scope rule
  def destroy?
    user.admin? || record.id.even?
  end

  # Experimental scope, only odd ids for regular users
  scope_for :array do |array|
    if user.admin?
      array
    else
      array.filter { |record| record.id.odd? }
    end
  end
end

Graphiti.setup!

ActionPolicy::Base.scope_matcher :array, Array
