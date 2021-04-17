require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require './spec/support/factory_bot.rb'
require './spec/support/test_helpers'
require 'webmock/rspec'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include TestHelpers
end

WebMock.allow_net_connect!
ActiveJob::Base.queue_adapter = :test

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!
  options.add_argument "--window-size=2400,3400"

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

if ENV['JAVASCRIPT_DRIVER'] == 'headless_chrome'
  Capybara.javascript_driver = :headless_chrome
else
  Capybara.javascript_driver = :chrome
end
