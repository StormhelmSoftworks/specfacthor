require 'specfac'
require 'thor'
module SpecFac
  class CLI < Thor
    desc "generate [actions]", "generates tests for specified actions"
    def generate(actions)

    end

    def pull_src(controller, actions)
      if !Dir.exists?(@working_dir)
        Dir.mkdir(@working_dir)
      end
      @working_file = "#{@working_dir}/#{controller.downcase}_controller_spec.rb"
      # Header stuff

      opener(
          "header",
          ["require 'rails_helper'","RSpec.describe #{controller.capitalize}Controller, type: :controller do"]
      )
      # p actions
      SpecModule.define_utils_methods_params(controller)
      actions != nil ? actions.each {|action| opener("body", SpecModule.public_send(action.to_sym))} : nil
      opener("end", "end")

    end

    def sanitize(controller, actions)
      rem = "_controller"
      if controller.include? "_controller"
        controller.gsub!(rem, "")
        # puts controller
      end
      if actions == "ALL"
        matched_actions = @available_methods
      else
        matched_actions = []
        actions = actions.split(" ")
        actions.each {|action| matched_actions << action if @available_methods.include?(action)}
      end

      # p matched_actions
      pull_src(controller, matched_actions)
    end
  end
end
