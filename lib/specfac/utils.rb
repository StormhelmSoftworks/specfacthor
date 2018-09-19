require 'active_support'
require 'active_support/core_ext/string'

module Utils
  @@term = nil

  def self.define_utils_methods_params(term)
    @@term = term
  end

  def self.si
    Utils.singularize(@@term)
  end

  def self.si_ca
    Utils.singularize(@@term.capitalize)
  end

  def self.pl
    Utils.pluralize(@@term)
  end

  def self.pluralize(string)
    return ActiveSupport::Inflector.pluralize(string)
  end

  def self.singularize(string)
    return ActiveSupport::Inflector.singularize(string)
  end

end