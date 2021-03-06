ASIN::Configuration.configure do |config|
  config.secret         = ENV['ASIN_SECRET']
  config.key            = ENV['ASIN_KEY']
  config.associate_tag  = ENV['ASIN_TAG']
  config.host           = 'webservices.amazon.de'
  config.logger         = Rails.logger
end
