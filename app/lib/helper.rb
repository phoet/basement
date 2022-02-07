require 'json'
require 'crack'
require 'hashie/mash'

class Helper
  class << self
    include Retry

    BASE_URL = 'http://picasaweb.google.com/data/feed/base/user/'

    def menu
      load_data :menu
    end

    def logger
      Rails.logger
    end

    def load_data(structure)
      YAML::load_file(Rails.root.join("config/data/#{structure}.yml")).map{ |item| Hashie::Mash.quiet.new(item) }
    end

    def get(url, format=:json)
      logger.info "fetching #{url} with format #{format}"
      resp = HTTPClient.new(agent_name: 'phoet.de').get(url, follow_redirect: true)
      return nil unless resp.status == 200
      content = resp.content
      case format
      when :json
        resp = JSON.parse(content)
        resp.is_a?(Array) ? resp.map{|r| Hashie::Mash.quiet.new(r)} : Hashie::Mash.quiet.new(resp)
      when :xml
        Hashie::Mash.quiet.new(Crack::XML.parse(content))
      when :raw
        content
      else
        raise "unsupported format #{format}"
      end
    rescue
      logger.info "serious fuckup #{$!}"
      nil
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
      with_retry do
        ASIN::Client.instance.lookup(asin, :ResponseGroup => :Medium).first
      end
    rescue
      raise "could not load book for #{asin} (#{$!})"
    end

    def amazon_books(asins)
      logger.info "fetching books for asins #{asins}"
      ASIN::Client.instance.lookup(asins, :ResponseGroup => :Medium)
    rescue
      raise "could not load books for #{asins} (#{$!})"
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
        if parsed = get(url, :json)
          parsed['feed']['entry'].map { |e| Picasa.new(e) }
        else
          []
        end
      end.flatten.shuffle
    end

    def twitter_client
      @client ||= begin
        Twitter::REST::Client.new do |config|
          config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
          config.access_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
        end
      end
    end

    def twitter_posts
      logger.info "calling twitter posts"
      twitter_client.search("@phoet").take(10)
    rescue
      nil
    end

    def twitter_friends
      logger.info 'calling twitter friends'
      twitter_client.friends.take(10)
    rescue
      logger.error "error calling twitter friends: #{$!}"
      nil
    end
  end
end
