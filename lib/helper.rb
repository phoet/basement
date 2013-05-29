require 'json'
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
      content = HTTPClient.new(agent_name: 'phoet.de').get(url, follow_redirect: true).content
      case format
      when :json
        resp = JSON.parse(content)
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
      get "https://api.github.com/users/phoet/gists?sort=pushed"
    end

    def repos
      repos = get "https://api.github.com/users/phoet/repos?sort=pushed"
      repos.sort{|a, b| b.forks + b.watchers <=> a.forks + a.watchers}
    rescue
      nil
    end

    def gist_files(gist)
      gist.files.map do |file|
        get file.second.raw_url, :raw
      end
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
      Twitter::Search.new.q("@phoet").fetch
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
  end
end
