require 'crack'

class Helper

  def self.menu
    load_data :menu
  end

  def self.logger
    Rails.logger
  end

  def self.load_data(structure)
    YAML::load_file("lib/data/#{structure}.yml").map{ |item| Hashie::Mash.new(item) }
  end

  def self.get(url, format=:json)
    content = HTTPClient.get(url).content
    if format == :json
      resp = Crack::JSON.parse(content)
      if resp.is_a? Array
        resp.map{|r| Hashie::Mash.new(r)}
      else
        Hashie::Mash.new(resp)
      end
    elsif format == :xml
      Hashie::Mash.new(Crack::XML.parse(content))
    elsif format == :raw
      content
    else
      raise "unsupported format #{format}"
    end
  end

  def self.gists
    url = 'https://gist.github.com/api/v1/json/gists/phoet'
    logger.info "fetching gists from #{url}"
    resp = get url
    resp.gists
  end

  def self.gist(gist_id, filename)
    url = "https://gist.github.com/raw/#{gist_id}/#{filename}"
    logger.info "fetching gist from #{url}"
    get url, :raw
  end

  def self.repos
    url = 'http://github.com/api/v1/json/phoet/'
    logger.info "fetching repos from #{url}"
    resp = get url
    resp.user.repositories.sort{|a, b| b.forks + b.watchers <=> a.forks + a.watchers}
  rescue
    nil
  end

  def self.commits(repo)
    url = "http://github.com/api/v1/json/phoet/#{repo}/commits/master"
    logger.info "fetching commit from #{url}"
    get url
  rescue
    nil
  end

  def self.amazon_book(asin)
    logger.info "fetching book for asin #{asin}"
    ASIN.client.lookup(asin, :ResponseGroup => :Medium)
  rescue
    raise "could not load book for #{asin} (#{$!})"
  end

  def self.blogger_posts
    logger.info 'calling blogger'
    parsed = get('http://uschisblogg.blogspot.com/feeds/posts/default?alt=json', :json)
    parsed['feed']['entry'].map { |e| Blogger.new(e) }
  rescue
    nil
  end

  BASE_URL = 'http://picasaweb.google.com/data/feed/base/user/'

  def self.picasa_fotos(urls=["#{BASE_URL}phoet6/?alt=json","#{BASE_URL}heddahh/?alt=json"])
    urls = [] << urls
    urls.flatten.map do |url|
      logger.info "calling picasa #{url}"
      parsed = get(url, :json)
      parsed['feed']['entry'].map { |e| Picasa.new(e) }
    end.flatten.shuffle
  end

  def self.twitter_posts
    logger.info "calling twitter posts"
    Twitter::Search.new.q('phoet').fetch
  end

  def self.twitter_friends
    logger.info 'calling twitter friends'
    json = get "https://twitter.com/statuses/friends/phoet.json"
    json.shuffle
  rescue
    nil
  end

  def self.seitwert
    logger.info 'calling seitwert'
    xml = get('http://www.seitwert.de/api/getseitwert.php?url=www.phoet.de&api=bfe1534821649e71c2694d0ace86fab0', :xml)
    xml.urlinfo
  rescue Timeout::Error
    nil
  end

end

