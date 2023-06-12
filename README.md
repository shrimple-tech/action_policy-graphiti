# Action Policy Graphiti

This gem allows you to use [Action Policy](https://github.com/palkan/action_policy) as an authorization framework for [Graphiti](https://www.graphiti.dev) applications.

The following features are currently enabled:

- Authorization of `create`, `update` and `destroy` actions
- Resource scoping

**This gem is under heavy development, was not yet released (since it is not production ready) so use it at your own risk!**

## Installation

**This gem was not yet released and can be installed only via a github link**

Add this line to your application's Gemfile:

```ruby
gem "action_policy-graphiti"
```

## Usage

The integration is done via including a behaviour module into your Graphiti resources:

```ruby
class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::Behaviour
end
```

Authorization of actions is done via using corresponding class methods:

```ruby
class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::Behaviour
  
  authorize_action :create
  authorize_action :update
  authorize_action :destroy
end
```
**Note:** current implementation requires you to place `authorize_` directives **after** `before_save` and `before_destroy` hooks (since it is adding authorization checks as hooks and we want them to be called **after** all the regular hooks were completed).

Scoping is done via adding the following class method call: 
```ruby
class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::Behaviour
  
  authorize_scope
end
```
**Note:** current implementation requires you to place `authorize_scope` call **after** the explicit `base_scope` method (scoping is performed by base scope results modification).

You can also use authorization context building inside Graphiti resources (just like with Action Policy in controllers):
```ruby
class TestResource < ApplicationResource
  include ActionPolicy::Graphiti::Behaviour
  
  authorize :parameter, through: :acquire_parameter
  
  def acquire_parameter
    # Your code goes here
  end
end
```
Or in a base class:
```ruby
class ApplicationResource < Graphiti::Resource
  include ActionPolicy::Graphiti::Behaviour
  
  authorize :parameter, through: :acquire_parameter
  
  def acquire_parameter
    # Your code goes here
  end
end
```
And then in a corresponding policy:
```ruby
class ApplicationPolicy < ActionPolicy::Base
  authorize :parameter
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shrimple-tech/action_policy-graphiti.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
