# frozen_string_literal: true

require "spec_helper"

describe "authorization results" do
  subject(:resource) { TestResource.find(data: { id: 1, type: "tests" }) }

  let(:regular_user) { User.new(role: "user") }
  let(:admin_user) { User.new(role: "admin") }
  it "fails to perform a prohibited action" do
    allow(resource.resource).to receive(:current_user).and_return(regular_user)

    expect { resource.save }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "fails to perform an admin-only action by a regular user" do
    allow(resource.resource).to receive(:current_user).and_return(regular_user)

    expect { resource.destroy }.to raise_error(ActionPolicy::Unauthorized)
  end

  it "allows to perform an admin-only action by an admin user" do
    allow(resource.resource).to receive(:current_user).and_return(admin_user)

    expect { resource.destroy }.not_to raise_error
  end
end
