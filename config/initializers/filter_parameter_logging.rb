# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched and filtered from the log file.
Rails.application.config.filter_parameters += [
  :passw, :password, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc
]
