# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_basement_rails3_session',
  :secret => '179f0e6d7ec282a66e8d3327434c7808ac91e062caeeef5bf55daaac45b3b9b0d568487611b26f4ffe867cce7b56057e032711ea000de6c313e7445f15b8269f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
