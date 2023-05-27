# frozen_string_literal: true

require "spec_helper"

describe "authorization results" do
  let(:created_resource) { TestResource.build(data: { type: "tests", attributes: { title: "Test" } }) }
  let(:managed_resource) { TestResource.find(data: { id: 1, type: "tests" }) }

  let(:regular_user) { User.new(role: "user") }
  let(:admin_user) { User.new(role: "admin") }

  it "fails to perform a prohibited create action" do
    allow(created_resource.resource).to receive(:current_user).and_return(regular_user)

    expect { created_resource.save }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "fails to perform an admin-only update action by a regular user" do
    allow(managed_resource.resource).to receive(:current_user).and_return(regular_user)

    expect { managed_resource.update_attributes }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "allows to perform an admin-only update action by an admin user" do
    allow(managed_resource.resource).to receive(:current_user).and_return(admin_user)

    expect { managed_resource.update_attributes }.not_to raise_error
  end

  it "fails to perform an admin-only destroy action by a regular user" do
    allow(managed_resource.resource).to receive(:current_user).and_return(regular_user)

    expect { managed_resource.destroy }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "allows to perform an admin-only destroy action by an admin user" do
    allow(managed_resource.resource).to receive(:current_user).and_return(admin_user)

    expect { managed_resource.destroy }.not_to raise_error
  end
end
