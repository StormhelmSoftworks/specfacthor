# Specfactor

Specfactor is a gem that generates commonly used tests for commonly used controller actions.

<p style="margin: 0 auto">
  <img src="https://img.shields.io/badge/version-0.1.8-green.svg">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg">
  <img src="https://img.shields.io/badge/downloads-1000+-red.svg">
   <img src="https://img.shields.io/badge/development-PRs Welcome-green.svg">
</p>

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

## Customizing Generated Tests

Specfactor allows for customization of modules used to generate tests. First, type:

    specfac extract <path to copy modules to>
    
Please indicate a path such as __Users/YOUR NAME/Desktop__. 
Do not include a beginning or ending "/". If you run into issues where Specfactor stops executing, it may be due to an invalid path supplied in the __extract__ command. 
If this is the case, you can access the path variable directly by going to your Ruby directory and
modifying the options.json file.

My directory is at __.rvm/gems/ruby-2.4.4/gems/specfactor/lib/specfac/options.json__

Here is an example:

    specfac extract Users/viktharien/Desktop
    
This will create a <code>modules</code> folder on my desktop. Inside the folder will be five ruby files:

    spec_module.rb
    factory_module.rb
    support_module.rb
    e2e_module.rb
    utils.rb
    
<code>spec_module</code> contains the templates for controller tests.

<code>factory_module</code> contains the templates for FactoryBot factories.

<code>support_module</code> contains the templates for DatabaseCleaner and FactoryBot configuration.

<code>e2e_module</code> contains the templates for Capybara tests.

<code>utils</code> contains utility code used by the templates, so don't modify or else things will break.

Replace or modify the code in these files and the next time you use Specfactor to generate tests,
your modifications will be used.

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
