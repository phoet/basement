# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem "rails", "3.0.0.beta"

## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

# ActiveRecord requires a database adapter. By default,
# Rails has selected sqlite3.
gem "sqlite3-ruby", "1.2.5", :require => "sqlite3"

## Bundle the gems you use:
gem "rails_redis_cache", "0.0.3"
gem "haml", "2.2.24"
gem "twitter", "0.9.12"
gem "hashie", "0.4.0"
gem "coderay", "0.9.3"
gem "asin", "0.0.8"
gem "doc_raptor", "0.1.0"

## Bundle gems used only in certain environments:
# gem "rspec", :group => :test
group :test do
  # gem "webrat"
  gem "test-unit", "1.2.3"
  gem "wirble", "0.1.3"
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :heroku do
  gem "heroku", "1.10.14"
end