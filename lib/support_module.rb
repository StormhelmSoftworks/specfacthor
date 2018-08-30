module SupportModule
  def self.factory_bot
    "RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end"
  end

  def self.database_cleaner

    "# RSpec.configure do |config|
    #
    #   config.before(:suite) do
    #     DatabaseCleaner.clean_with(:truncation)
    #   end
    #
    #   config.before(:each) do
    #     DatabaseCleaner.strategy = :transaction
    #   end
    #
    #   config.before(:each, :js => true) do
    #     DatabaseCleaner.strategy = :truncation
    #   end
    #
    #   config.before(:each) do
    #     DatabaseCleaner.start
    #   end
    #
    #   config.after(:each) do
    #     DatabaseCleaner.clean
    #   end
    #
    # end
    #
    RSpec.configure do |config|
      config.use_transactional_fixtures = false
      config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
      config.before(:each) { DatabaseCleaner.strategy = :transaction }
      config.before(:each, :js => true) { DatabaseCleaner.strategy = :truncation }
      config.before(:each) { DatabaseCleaner.start }
      config.after(:each) { DatabaseCleaner.clean }
    end"
  end

end