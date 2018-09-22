require 'json'
require 'fileutils'
require 'thor'
gem_path = 'specfac'
mod_path = 'modules'
lib_path = "/lib/#{gem_path}"
abs_dir_path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
path_join = lambda { |dir_path, file_path| dir_path + file_path }
options_path = path_join.call(abs_dir_path,"#{lib_path}/options.json")
options = JSON.parse(File.read(options_path))
selector = options['path']


actual_path =  if selector == 'root'
    gem_path
  else
    selector = selector[0] == "/" ? selector : "/#{selector}"
    $LOAD_PATH.unshift(selector)

    Dir.mkdir(selector) if !Dir.exists?(selector)
    FileUtils.cp_r(path_join.call(abs_dir_path,"#{lib_path}/#{mod_path}/"), selector)

    selector
  end

#### After directory preparation, require modules ####

require "#{gem_path}"
require "#{gem_path}/version"
require "#{actual_path}/#{mod_path}/spec_module"
require "#{actual_path}/#{mod_path}/factory_module"
require "#{actual_path}/#{mod_path}/support_module"
require "#{actual_path}/#{mod_path}/e2e_module"

module Specfac
  class CLI < Thor
    include Utils
    include SpecModule
    include FactoryModule
    include SupportModule
    include E2eModule

    attr_accessor :dir_support,
                  :dir_controllers,
                  :dir_factories,
                  :dir_features,
                  :working_dirs,
                  :working_file,
                  :available_methods,
                  :paths

    ######### AVAILABLE COMMANDS

    # desc "test_command", "a test command for testing"
    # option :f, :type => :boolean
    # option :e, :type => :boolean
    # def test_command(*args)
    #   puts options
    #   puts args
    # end

    # -----
    #
    #


    desc "extract [destination]", "Extracts the Specfactor base modules to the destination specified for customization"
    method_option :aliases => "ex"
    def extract(dest)
      @paths = $paths
      @paths[:options]["path"] = dest
      opener(nil, @paths[:options].to_json, "w", @paths[:options_path])
    end

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

      def opener(mode, lines, open_type, file = @working_file)
        filer = lambda do |type, output|
          File.open(file, type) { |handle| handle.puts output}
        end

        if mode == "spec" || mode == "feature"
          filer.call(open_type, nil)
          lines.each do |item|
            filer.call("a", item)
          end
        elsif mode == "end"
          filer.call(open_type, lines)
        else
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

$paths = {
    :gem_path => gem_path,
    :lib_path => lib_path,
    :mod_path => mod_path,
    :abs_path => abs_dir_path,
    :options_path => options_path,
    :options => options,
    :path_join => path_join,
    :selector => selector
}




