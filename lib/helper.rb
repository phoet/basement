class Helper
  
  extend ASIN

  MenuItem = Struct.new(:id, :name, :subitems)

  def self.menu
    load_data :menu
  end

  def self.logger
    Rails.logger
  end

  def self.load_data(structure)
    YAML::load_file("lib/data/#{structure}.yml")
  end

  def self.dump(structure, filename='dump')
    File.open("tmp/#{filename}.yml", 'w') do |out|
      out.write(structure.to_yaml)
    end
  end

  def self.get(url, format)
    HTTParty.get(url, :format=>format, :timeout=>10)
  end
  
  def self.gists
    resp = HTTParty.get 'http://gist.github.com/api/v1/json/gists/phoet', :type=>:json
    resp = Hashie::Mash.new resp
    resp.gists
  end
  
  def self.gist(gist_id, filename)
    HTTParty.get "http://gist.github.com/raw/#{gist_id}/#{filename}"
  end
  
  def self.repos
    resp = HTTParty.get 'http://github.com/api/v1/json/phoet/', :type=>:json
    resp = Hashie::Mash.new resp
    resp.user.repositories
  rescue
    nil
  end
  
  def self.commits(repo)
    resp = HTTParty.get "http://github.com/api/v1/json/phoet/#{repo}/commits/master", :type=>:json
    Hashie::Mash.new resp
  rescue
    nil
  end

  def self.amazon_book(asin)
    begin
      configure :secret => '4w5ApABP2dALi4/8bdqm9xIcZ8GPe0P0PnocXNTB', :key => 'AKIAJFA5X7RTOKFNPVZQ', :host => 'webservices.amazon.de'
      p item = lookup(asin, :ResponseGroup => :Medium)
      item
    rescue
      raise "could not load book for #{asin} (#{$!})"
    end
  end

  def self.blogger_posts
    logger.info 'calling blogger'
    parsed = get('http://uschisblogg.blogspot.com/feeds/posts/default?alt=json', :json)
    parsed['feed']['entry'].map do |e| 
      Blogger.new(e)
    end
  rescue
    []
  end

  BASE_URL = 'http://picasaweb.google.com/data/feed/base/user/'

  def self.picasa_fotos(urls=["#{BASE_URL}phoet6/?alt=json","#{BASE_URL}heddahh/?alt=json"])
    urls = [urls] if urls.is_a? String
    urls.map do |url|
      logger.info "calling picasa #{url}"
      parsed = get(url, :json)
      parsed['feed']['entry'].map do |e| 
        Picasa.new(e)
      end
    end.flatten.sort_random
  end

  def self.twitter_posts
    endpoint = "#{ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']}/search"
    logger.info "calling twitter posts with #{endpoint}"
    Twitter::Search.new('phoet', api_endpoint: endpoint)
  end

  def self.twitter_friends
    logger.info 'calling twitter friends'
    json = get("http://twitter.com/statuses/friends/phoet.json", :json)
    if json.is_a? Array
      json.map do |json|
        TwitterUser.new(json)
      end
    else
      []
    end
  rescue
    []
  end

  def self.seitwert
    logger.info 'calling seitwert'
    xml = get('http://www.seitwert.de/api/getseitwert.php?url=www.phoet.de&api=bfe1534821649e71c2694d0ace86fab0', :xml)
    [Hashie::Mash.new(xml['urlinfo'])]
  rescue Timeout::Error
    []
  end

end