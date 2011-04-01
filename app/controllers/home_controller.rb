class HomeController < ApplicationController
  
  skip_before_filter :prepare_cache, :only => [:reset_cache]

  def index
    @cite = @cites[rand(@cites.size)]
    more_stuff(@friends.size) do |count|
      @friends[0..count]
    end if @friends
  end

  def gallery
    more_stuff(@fotos.size) do |count|
      @fotos[0..count].each.map do |foto|
        (@picture_hash ||= {})[foto.album_id] = cache_and_set(:"gallery_images_#{foto.album_id}"){Helper::picasa_fotos(foto.pictures_url)}
        foto
      end
    end
  end

  def blog
    more_stuff(@posts.size) do |count|
      @posts[0..count]
    end
  end

  def sitemap
    response.headers["Content-Type"] = 'text/xml'
    render :layout=>false
  end

  def reset_cache
    render :text=>"reset redis cache: #{cache_store.redis.flushdb}"
  end

end
