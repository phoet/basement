require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "active_resource/railtie"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Basement
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )
    # config.autoload_paths += %W( #{config.root}/lib )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    config.generators do |g|
      g.orm             :none
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => false
    end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    
    config.secret_token = '1ba21b11a5e1fb5d128e3b0665417064f6dd279b09b15fdabe6ba5c256031d0ea4f352169bc854bb78ec4959f1b29eaebe547862cbb40ea2991a4ec15a5678cd'
    config.session_store :cookie_store, :key => '_basement_rails3_session', :secret => '179f0e6d7ec282a66e8d3327434c7808ac91e062caeeef5bf55daaac45b3b9b0d568487611b26f4ffe867cce7b56057e032711ea000de6c313e7445f15b8269f'
  end
end
