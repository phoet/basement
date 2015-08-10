source "http://rubygems.org"
ruby   File.read('.ruby-version').chomp

gem "rails", "3.2.22"
gem "haml"
gem "asin", "2.0.1"
gem "twitter", "4.8.1"
gem "httpclient", "~> 2.6"
gem "thin", "1.6.3"
gem "jquery-rails"
gem "rails_autolink"
gem "dalli"
gem "exception_notification"
gem "vpim"

group :production do
  gem "rails_log_stdout"
  gem "rails_12factor"
end

group :assets do
  gem "sass-rails",   "3.2.5"
  gem "uglifier",     "1.3.0"
end

group :development, :test do
  gem "pry-remote"
  gem "test-unit"
  gem "rspec-rails", "~> 2.14"
end
