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
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::Null

  attr_reader :current_user

  def admin?
    current_user.admin?
  end
end

class TestModel
  ATTRS = %i[id title].freeze
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
  { id: 1, title: "Test" }
]

class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::AutomaticallyAuthorized

  self.model = TestModel

  authorize_action :create
  authorize_action :destroy

  attribute :title, :string

  def base_scope
    {}
  end

  def resolve(_scope)
    TEST_MODEL_DATA.map { |d| TestModel.new(d) }
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
end

class TestPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    false
  end

  def destroy?
    user.admin?
  end
end

Graphiti.setup!
