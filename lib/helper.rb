require 'crack'
require 'hashie/mash'

class Helper
  class << self
    BASE_URL = 'http://picasaweb.google.com/data/feed/base/user/'

    def menu
      load_data :menu
    end

    def logger
      Rails.logger
    end

    def load_data(structure)
      YAML::load_file("lib/data/#{structure}.yml").map{ |item| Hashie::Mash.new(item) }
    end

    def get(url, format=:json)
      logger.info "fetching #{url} with format #{format}"
      content = HTTPClient.get(url).content
      case format
      when :json
        resp = Crack::JSON.parse(content)
        resp.is_a?(Array) ? resp.map{|r| Hashie::Mash.new(r)} : Hashie::Mash.new(resp)
      when :xml
        Hashie::Mash.new(Crack::XML.parse(content))
      when :raw
        content
      else
        raise "unsupported format #{format}"
      end
    end

    def gists
      resp = get 'https://gist.github.com/api/v1/json/gists/phoet'
      resp.gists
    end

    def gist(gist_id, filename)
      get "https://gist.github.com/raw/#{gist_id}/#{filename}", :raw
    end

    def repos
      resp = get 'http://github.com/api/v1/json/phoet/'
      resp.user.repositories.sort{|a, b| b.forks + b.watchers <=> a.forks + a.watchers}
    rescue
      nil
    end

    def commits(repo)
      get "http://github.com/api/v1/json/phoet/#{repo}/commits/master"
    rescue
      nil
    end

    def amazon_book(asin)
      logger.info "fetching book for asin #{asin}"
      ASIN::Client.instance.lookup(asin, :ResponseGroup => :Medium).first
    rescue
      raise "could not load book for #{asin} (#{$!})"
    end

    def blogger_posts
      parsed = get('http://uschisblogg.blogspot.com/feeds/posts/default?alt=json', :json)
      parsed['feed']['entry'].map { |e| Blogger.new(e) }
    rescue
      nil
    end

    def picasa_fotos(urls=["#{BASE_URL}phoet6/?alt=json","#{BASE_URL}heddahh/?alt=json"])
      urls = [] << urls
      urls.flatten.map do |url|
        parsed = get(url, :json)
        parsed['feed']['entry'].map { |e| Picasa.new(e) }
      end.flatten.shuffle
    end

    def twitter_posts
      logger.info "calling twitter posts"
      Twitter::Search.new.q("phoet").fetch
    rescue
      nil
    end

    def twitter_friends
      logger.info 'calling twitter friends'
      Twitter.follower_ids("phoet").ids.shuffle[0..4].map { |id| Twitter.user(id) }
    rescue
      logger.error "error calling twitter friends: #{$!}"
      nil
    end

    def seitwert
      logger.info 'calling seitwert'
      xml = get('http://www.seitwert.de/api/getseitwert.php?url=www.phoet.de&api=bfe1534821649e71c2694d0ace86fab0', :xml)
      xml.urlinfo
    rescue Timeout::Error
      nil
    end
  end
end
