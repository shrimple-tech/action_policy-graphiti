# frozen_string_literal: true

require "spec_helper"

describe "authorization results" do
  # let(:created_resource) { TestResource.build(data: { type: "tests", attributes: { title: "Test" } }) }
  # let(:managed_resource) { TestResource.find(data: { id: 1, type: "tests" }) }

  let(:regular_user) { User.new(role: "user") }
  let(:admin_user) { User.new(role: "admin") }

  it "fails to perform a prohibited create action" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(regular_user)
    created_resource = TestResource.build(data: { type: "tests", attributes: { title: "Test" } })

    expect { created_resource.save }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "fails to perform an admin-only update action by a regular user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(regular_user)
    managed_resource = TestResource.find(data: { id: 1, type: "tests" })

    expect { managed_resource.update_attributes }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "allows to perform an admin-only update action by an admin user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(admin_user)
    managed_resource = TestResource.find(data: { id: 1, type: "tests" })

    expect { managed_resource.update_attributes }.not_to raise_error
  end

  it "fails to perform an admin-only destroy action by a regular user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(regular_user)
    managed_resource = TestResource.find(data: { id: 1, type: "tests" })

    expect { managed_resource.destroy }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "allows to perform an admin-only destroy action by an admin user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(admin_user)
    managed_resource = TestResource.find(data: { id: 1, type: "tests" })

    expect { managed_resource.destroy }.not_to raise_error
  end

  it "fails to find an admin-only accessible resource by a regular user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(regular_user)
    scope = TestResource.new.base_scope
    scope_admin_only_part = scope.filter { |item| item.id.even? }

    expect(scope_admin_only_part).to eq([])
  end

  it "allows to find an admin-only accessible resource by an admin user" do
    allow_any_instance_of(TestResource).to receive(:current_user).and_return(admin_user)
    scope = TestResource.new.base_scope
    scope_admin_only_part = scope.filter { |item| item.id.even? }

    expect(scope_admin_only_part).not_to eq([])
  end
end
