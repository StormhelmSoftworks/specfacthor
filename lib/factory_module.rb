require 'specfac_utils'

module FactoryModule
  include Utils

  def self.create
    "FactoryBot.define do
      factory :#{Utils.si} do
        # insert attributes

        factory :invalid_#{Utils.si} do
          # insert attributes
        end

        factory :updated_#{Utils.si} do
          # insert attributes
        end

        factory :second_#{Utils.si} do
          # insert attributes
        end
      end
    end"
  end
end