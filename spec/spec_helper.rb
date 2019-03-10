require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
 
  # Mongoid models reload
  require 'rails/mongoid'
  Spork.trap_class_method(Rails::Mongoid, :load_models)
 
  # Routes and app/ classes reload
  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  Spork.trap_method(Rails::Application, :eager_load!)
 
  # Load railties
  require File.expand_path('../../config/environment', __FILE__)
  Rails.application.railties { |r| r.eager_load! }
 
  # General require
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'database_cleaner'
 
  RSpec.configure do |config|
    config.mock_with :rspec
 
    # Clean up the database
    config.before(:suite) do
      DatabaseCleaner[:mongoid].strategy = :truncation, {:except => %w[users] }
    end
    config.before(:each)  { DatabaseCleaner.clean }
  end
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  Dir.glob(File.dirname(__FILE__) + "/factories/*").each {|factory| require factory }
  FactoryGirl.reload
  I18n.backend.reload!
  Dir[Rails.root.join('spec/views/**/*.rb')].each   {|f| require f}
end
