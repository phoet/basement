class TwitterUser
  def initialize(json)
    @json = json
  end
  
  def name
    @json['name']
  end
  
  def screen_name
    @json['screen_name']
  end
  
  def friends_count
    @json['followers_count']
  end
  
  def thumbnail
    @json['profile_image_url']
  end
  
  def has_status?
    !@json['status'].nil?
  end
  
  def status_text
    @json['status']['text']
  end
  
  def status_created
    @json['status']['created_at']
  end
  
end