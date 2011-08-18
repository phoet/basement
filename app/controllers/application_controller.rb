require 'google_data'
require 'blogger'
require 'picasa'
require 'helper'
require 'hashie/rash'

class ApplicationController < ActionController::Base

  protect_from_forgery
  helper :all

  before_filter :prepare_cache
  
  helper_method :my_helper

  # prepare all the caching and loading-stuff for each request
  def prepare_cache
    @rendering_start = Time.new
    cache_and_set(:tweets)    { my_helper.twitter_posts }
    cache_and_set(:friends)   { my_helper.twitter_friends }
    cache_and_set(:fotos)     { my_helper.picasa_fotos }
    cache_and_set(:posts)     { my_helper.blogger_posts }
    cache_and_set(:books)     { my_helper.load_data(:books).shuffle }
    cache_and_set(:seitwert)  { my_helper.seitwert }
    cache_and_set(:repos)     { my_helper.repos }
    cache_and_set(:gists)     { my_helper.gists }

    @cites = my_helper.load_data(:cites).shuffle
    @teaser = [:blog, :bookshelf, :gallery, :twitter, :repos, :gists]
    2.times.each{@teaser.delete_at(rand(@teaser.size))}
  end

  # extend render-method to not render a layout for xhr requests
  def render(*args)
    args << {:layout=>false} if request.xhr? and args.empty?
    args.first[:layout] = false if request.xhr? and args.first[:layout].nil?
    response.headers['Cache-Control'] = 'public, max-age=12000'
    super
  end

  private()
  
  def my_helper
    Helper.instance
  end

  # generic helper for adding more results to view
  def more_stuff(size, initial_count=3)
    unless params[:id].nil?
      session[action_name] = params[:id].to_i
      session[action_name] = (size - 1) if session[action_name] >= size
    end
    @more_array = yield session[action_name] ||= initial_count
  end

  def cache_and_set(key, &to_cache)
    data = cache("#{key}", {:expires_in => CACHE_TIME}, &to_cache)
    instance_variable_set(:"@#{key}", data) if data
  rescue
    logger.error "error caching key=#{key} (#{$!})"
    raise
  end

end
