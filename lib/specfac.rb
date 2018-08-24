require 'specfac'
require 'thor'
require 'spec_module'
require 'factory_module'
module SpecFac
  class CLI < Thor
    include Utils
    include SpecModule
    include FactoryModule
    attr_accessor :dir_controllers, :dir_factories, :working_dirs, :working_file, :protected_methods, :available_methods, :found_methods

    ######### AVAILABLE COMMANDS
    desc "generate [controller] [actions]", "generates tests for specified actions"
    method_option :aliases => "g"
    option :f, :type => :boolean
    def generate(*args)
      @working_dirs = ["spec", "controllers", "factories"]
      @dir_controllers = "#{@working_dirs[0]}/#{@working_dirs[1]}"
      @dir_factories = "#{@working_dirs[0]}/#{@working_dirs[2]}"
      # @protected_methods = %w(define_utils_methods_params si si_ca pl)
      @found_methods = SpecModule.methods(false).to_a.map {|item| item.to_s}
      @available_methods = @found_methods # @found_methods - @protected_methods
      @working_file = nil

      controller = args.shift
      actions = args




      if controller
        sanitize(controller, actions)
      else
        puts "Please provide a controller name."
        exit
      end

      # Factories

      if options[:f]
        controller != nil ? @working_file = "#{@dir_factories}/#{controller.downcase}_spec.rb" : @working_file = "#{@dir_factories}/sample_spec.rb"
        opener("factory", FactoryModule.create)
      end
    end

    ######## UTILITY METHODS
    #

    no_commands do
      def create_directories(*dirs)
        dirs.each {|dir| Dir.mkdir(dir) if !Dir.exists?(dir) }

      end

      def pull_src(controller, actions)
        create_directories(@working_dirs[0], @dir_controllers, @dir_factories)
        @working_file = "#{@dir_controllers}/#{controller.downcase}_controller_spec.rb"
        # Spec tests

        opener(
            "header",
            ["require 'rails_helper'","RSpec.describe #{controller.capitalize}Controller, type: :controller do"]
        )

        Utils.define_utils_methods_params(controller)
        actions != nil ? actions.each {|action| opener("body", SpecModule.public_send(action.to_sym))} : nil
        opener("end", "end")



      end

      def opener(mode, lines)
        filer = lambda {|type, output| File.open(@working_file, type) { |handle| handle.puts output}}
        if mode == "header"
          filer.call("w", nil)
          lines.each do |item|
            filer.call("a", item)
          end
        else
          filer.call("a", lines)
        end
      end

      def sanitize(controller, actions)

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
        pull_src(controller, matched_actions)
      end
    end


  end
end
