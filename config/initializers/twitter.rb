Twitter.configure do |config|
  config.endpoint = "#{ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']}/search"
end
