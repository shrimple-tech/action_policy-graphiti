# frozen_string_literal: true

require "spec_helper"

describe "authorization results" do
  subject(:resource) { TestResource.build(data: { type: "tests" }) }

  it "fails to perform a prohibited action" do
    expect { resource.save }.to raise_error(ActionPolicy::Unauthorized)
  end
end
