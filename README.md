# Specfactor

Specfactor is a gem that generates commonly used tests for commonly used controller actions.

## Installation

Specfactor is dependent on these gems: 

    rspec-rails
    activesupport
    factory_bot_rails
    
Provided you are developing on Rails, activesupport should be included by default.
Specfactor generates tests that utilize factories, and so FactoryBot is recommended. Otherwise, simply comment out/delete parts of the tests you don't want to use.

Add this line to your application's Gemfile:

```ruby
gem 'specfactor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specfactor

## Usage

In terminal, type:

    specfac generate -options <controller> <actions>
    
   or
    
    specfac g -options <controller> <actions>
    
__[controller]__ should be the name of the controller you'd like to generate tests for

__[actions]__ should be the names of methods to be generated

An example usage for specific tests:

    specfac generate participants index show
    
An example for all available tests:
    
    specfac g participants ALL
    
An example generating a FactoryBot factory for the controller:

    specfac generate -f dogs ALL
    
An example generating Capybara End-to-End/Feature tests for the controller:

    specfac g -e cats ALL
    
Or generate both E2E tests and the Factory:

    specfac g -f -e dragons index show
    
Currently, tests can be generated for :index, :show, :new, :create, :edit, :update, and :destroy.

## Other Commands

To generate configuration settings for DatabaseCleaner and FactoryBot:

    specfac setup factory_bot
    
    specfac setup database_cleaner
    
To print the version number for Specfactor:

    specfac -v
    
    specfac --version

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viktharien/specfacthor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
