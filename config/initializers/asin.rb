class ASIN::SimpleItem
  def marshal_dump
    JSON.dump @raw.to_hash
  end

  def marshal_load(json)
    @raw = Hashie::Mash.new(JSON.parse(json))
  end
end

ASIN::Configuration.configure do |config|
  config.secret         = ENV['ASIN_SECRET']
  config.key            = ENV['ASIN_KEY']
  config.associate_tag  = ENV['ASIN_TAG']
  config.host           = 'webservices.amazon.de'
  config.logger         = Rails.logger
end
