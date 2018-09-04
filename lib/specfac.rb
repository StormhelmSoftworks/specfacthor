require 'specfac'
require 'specfac/version'
require 'thor'
require 'spec_module'
require 'factory_module'
require 'support_module'
require 'e2e_module'
module Specfac
  class CLI < Thor
    include Utils
    include SpecModule
    include FactoryModule
    include SupportModule
    include E2eModule

    attr_accessor :dir_support, :dir_controllers, :dir_factories, :dir_features, :working_dirs, :working_file, :available_methods

    ######### AVAILABLE COMMANDS

    # desc "test_command", "a test command for testing"
    # option :f, :type => :boolean
    # option :e, :type => :boolean
    # def test_command(*args)
    #   puts options
    #   puts args
    # end

    # -----

    desc "generate [controller] [actions]", "Generates tests for specified actions. Separate actions with spaces."
    method_option :aliases => "g"
    option :f, :type => :boolean #factory
    option :e, :type => :boolean #end to end tests
    def generate(*args)
      init_vars(options)

      controller = args.shift
      actions = args

      if controller
        sanitize(controller, actions, options)
      else
        puts "Please provide a controller name."
        exit
      end
    end

    #-----

    map %w[--version -v] => :__print_version
    desc "--version, -v", "Shows the currently active version of Specfactor."
    def __print_version
      puts Specfac.show_v
    end

    #-----
    #
    desc "setup [types] 'i.e. setup factory_bot'", "Generates RailsHelper configuration files for 'factory_bot' and 'database_cleaner'."
    def setup(*args)
      init_vars
      @working_file = "#{@dir_support}/specfac/config.rb"
      args != nil ? args.each {|arg| opener("support", SupportModule.public_send(arg.to_sym), "a")} : nil
      puts "Generating support: #{@working_file}"
      sleep 1
      puts "> completed"
    end

    ######## UTILITY METHODS
    #

    no_commands do
      def init_vars(options=nil)
        @working_dirs = ["spec", "controllers", "factories", "support", "features"]
        @dir_support = "#{@working_dirs[0]}/#{@working_dirs[3]}"
        @dir_controllers = "#{@working_dirs[0]}/#{@working_dirs[1]}"
        @dir_factories = "#{@working_dirs[0]}/#{@working_dirs[2]}"
        @dir_features = "#{@working_dirs[0]}/#{@working_dirs[4]}"
        @available_methods = SpecModule.methods(false).to_a.map {|item| item.to_s}
        @working_file = nil

        create_directories(@working_dirs[0])

        if options
          create_directories(@dir_controllers)
          if options[:f]
            create_directories(@dir_factories)
          end
          if options[:e]
            create_directories(@dir_features)
          end
        else
          create_directories(@dir_support, "#{@dir_support}/specfac")
        end

      end

      def create_directories(*dirs)
        dirs.each {|dir| Dir.mkdir(dir) if !Dir.exists?(dir) }
      end

      def pull_src(controller, actions, options=nil)

        @working_file = "#{@dir_controllers}/#{controller.downcase}_controller_spec.rb"
        # Spec tests

        opener(
            "spec",
            ["require 'rails_helper'","RSpec.describe #{controller.capitalize}Controller, type: :controller do"],
            "w"
        )

        Utils.define_utils_methods_params(controller)
        actions != nil ? actions.each {|action| opener("tests", SpecModule.public_send(action.to_sym), "a")} : nil
        opener("end", "end", "a")

        # Factories

        if options
          if options[:f]
            puts
            @working_file = "#{@dir_factories}/#{Utils.pluralize(controller.downcase)}.rb"
            opener("factory", FactoryModule.create, "w")
            opener("end", nil, "a")
          end

          # end to end tests

          if options[:e]
            puts
            @working_file = "#{@dir_features}/#{Utils.pluralize(controller.downcase)}_spec.rb"
            opener("feature",
                   ["require 'rails_helper'", "describe 'navigation' do"],
                   "w")
            actions != nil ? actions.each {|action| opener("tests", E2eModule.public_send(action.to_sym), "a")} : nil
            opener("end", "end", "a")
          end
        end


      end

      def opener(mode, lines, open_type)
        filer = lambda do |type, output|
          File.open(@working_file, type) { |handle| handle.puts output}
        end

        if mode == "spec" || mode == "feature"
          puts "Creating #{mode}: #{@working_file}."
          filer.call(open_type, nil)
          lines.each do |item|
            filer.call("a", item)
          end
        elsif mode == "end"
          puts "> completed"
          filer.call(open_type, lines)
        else
          puts "Creating #{mode}: #{@working_file}"
          filer.call(open_type, lines)
        end
      end

      def sanitize(controller, actions, options)

        rem = "_controller"
        if controller.include? "_controller"
          controller.gsub!(rem, "")
          # puts controller
        end
        if actions.include?("ALL")
          matched_actions = @available_methods
        else
          matched_actions = []
          actions.each {|action| matched_actions << action if @available_methods.include?(action)}
        end

        # p matched_actions
        pull_src(controller, matched_actions, options)
      end
    end


  end
end
