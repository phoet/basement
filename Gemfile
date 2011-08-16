source :gemcutter

gem "rails", "~> 3.0.9"

gem "rails_redis_cache", "~> 0.0.4"
gem "haml", "~> 3.1.2"
gem "asin", "~> 0.6.0"
gem "twitter", "~> 1.4.1"
gem "coderay", "~> 0.9.8"
gem "httpclient", "~> 2.2.0.2"
gem "thin", "~> 1.2.11"
gem "foreman", "~> 0.19.0"

group :production do
  gem "pg", "~> 0.11.0" # env ARCHFLAGS="-arch x86_64" gem install pg
end

group :development do
  gem "heroku"
  gem "wirble"
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'rspec', "~> 2.6.0"
  gem 'rspec-rails', "~> 2.6.0"
end
