require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv::Railtie.load
end

module Scrbabble
  class Application < Rails::Application
    config.load_defaults 6.1
  end
end
