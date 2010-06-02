# load all classes from lib
require 'amazon_data'
require 'blogger'
require 'google_data'
require 'picasa'
require 'seitwert'
require 'twitter_user'

class Storage < ActiveRecord::Base
  
  validates_presence_of :key, :data
  
  def data=(data)
    write_attribute :data, ActiveSupport::Base64.encode64(Marshal.dump(data))
  end
  
  def data
    Marshal.load(ActiveSupport::Base64.decode64(read_attribute :data))
  end
  
end
