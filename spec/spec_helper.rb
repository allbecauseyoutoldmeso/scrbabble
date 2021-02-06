require File.expand_path("../../config/environment", __FILE__)
require './spec/support/factory_bot.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

# need to set rspec up properly for rails!
