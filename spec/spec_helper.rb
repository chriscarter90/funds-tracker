require 'simplecov'
SimpleCov.start 'rails'
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 4

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include Devise::TestHelpers, :type => :controller

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Specify metadata using symbols only.
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before :suite do
    DatabaseCleaner.clean_with :truncation

    begin
      puts "Linting factories..."
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  # Use transactional database cleaning strategy by default.
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  # Use truncation for tests where Capybara fires up external browser environments,
  # such as Poltergeist.
  config.before :each, js: true do
    DatabaseCleaner.strategy = :truncation
  end

  # Execute whatever cleanup strategy we selected beforehand.
  config.before :each do
    DatabaseCleaner.start
  end

  # Clean the database after each test.
  config.after :each do
    DatabaseCleaner.clean
  end
end