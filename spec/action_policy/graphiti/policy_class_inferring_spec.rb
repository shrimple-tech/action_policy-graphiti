# frozen_string_literal: true

require "spec_helper"

describe "policy inferring" do
  subject(:resource) { TestResource.new }
  it "infers policy class for a Graphiti resource" do
    expect(ActionPolicy.lookup(resource)).to eq(TestPolicy)
  end
end
