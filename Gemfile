source 'http://rubygems.org'

gem 'rails', '3.1.0.rc6'

gem "rails_redis_cache", git: 'git://github.com/phoet/rails_redis_cache.git', ref: '329e98825e157095cba5'
gem "haml", "~> 3.1.2"
gem "asin", "~> 0.6.0"
gem "twitter", "~> 1.4.1"
gem "coderay", "~> 0.9.8"
gem "httpclient", "~> 2.2.0.2"
gem "thin", "~> 1.2.11"
gem "foreman", "~> 0.19.0"
gem "rails_autolink", "~> 1.0.2"

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
end

group :development do
  gem "heroku"
  gem "wirble"
  gem 'ruby-debug19', require: 'ruby-debug'
end

group :test do
  gem 'rspec', "~> 2.6.0"
  gem 'rspec-rails', "~> 2.6.0"
end
