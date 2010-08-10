# Load the rails application
require File.expand_path('../application', __FILE__)

ActionController::Base.cache_store = ActiveSupport::Cache::RailsRedisCache.new(:url => ENV['RAILS_REDIS_CACHE_URL'])

# Initialize the rails application
BasementRails3::Application.initialize!
