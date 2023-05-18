# frozen_string_literal: true

require_relative "lib/action_policy/graphiti/version"

Gem::Specification.new do |spec|
  spec.name = "action_policy-graphiti"
  spec.version = ActionPolicy::Graphiti::VERSION
  spec.authors = ["Andrei Mochalov"]
  spec.email = ["factyy@gmail.com"]

  spec.summary = "This gem allows you to use a JSON:API implementation (Graphiti) with ActionPolicy."
  spec.description = "This gem allows you to use a JSON:API implementation (Graphiti) with ActionPolicy"
  spec.homepage = "https://github.com/shrimple-tech/action_policy-graphiti"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]

  spec.require_paths = ["lib"]

  spec.add_dependency "action_policy", "~> 0.6"
  spec.add_dependency "graphiti", "~> 1.3"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "debug", "~> 1.8"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "rspec", ">= 3.8"
  spec.add_development_dependency "solargraph", "~> 0.41"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
