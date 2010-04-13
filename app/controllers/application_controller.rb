class ApplicationController < ActionController::Base

  protect_from_forgery
  helper :all
  layout 'default'

  Book = Struct.new(:asin, :title)
  Cite = Struct.new(:author, :text)
  Feed = Struct.new(:type, :title, :site, :url)

  before_filter :prepare_cache

  # prepare all the caching and loading-stuff for each request
  def prepare_cache
    @rendering_start = Time.new
    cache(:tweets){Helper::twitter_posts}
    cache(:friends){Helper::twitter_friends.sort_random}
    cache(:fotos){Helper::picasa_fotos}
    cache(:posts){Helper::blogger_posts}
    cache(:books){Helper::load_data(:books).sort_random}
    cache(:seitwert){Helper::seitwert}
    cache(:repos){Helper::repos}

    # cache can just handle arrays
    @seitwert = @seitwert[0]

    @random_gallary_images = @fotos.sort_random
    @cites = Helper::load_data(:cites).sort_random
    @feeds = Helper::load_data(:feeds).sort_random
    
    @teaser = [:blog, :bookshelf, :gallery, :twitter, :feed, :github]
    @teaser.delete_at(rand(@teaser.size))
  end

  # extend render-method to not render a layout for xhr requests
  def render(*args)
    args << {:layout=>false} if request.xhr? and args.empty?
    args.first[:layout] = false if request.xhr? and args.first[:layout].nil?
    response.headers['Cache-Control'] = 'public, max-age=12000'
    super
  end

  private

  # generic helper for adding more results to view
  def more_stuff(size, initial_count=3)
    unless params[:id].nil?
      session[action_name] = params[:id].to_i
      session[action_name] = size -1 if session[action_name] >= size
    end
    @more_array = yield session[action_name] ||= initial_count
  end

  def cache(key, &to_cache)
    # p "db_cache #{key}"
    from_db = Storage.first(:conditions => {:key => key})
    # p "in db #{from_db.inspect}"
    if from_db.nil? || from_db.updated_at < Time.new - CACHE_TIME
      # p "fetching for db #{key}"
      data = (yield to_cache).collect{|t|t}
      return [] if data.nil? || data.empty?
      from_db = (from_db || Storage.new)
      from_db.key = key
      from_db.data = data
      from_db.save!
    end
    instance_variable_set :"@#{key.to_s}", from_db.data
  end
  
end
