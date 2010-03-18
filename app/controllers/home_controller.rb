class HomeController < ApplicationController
  def index
    @cite = @cites[rand(@cites.size)]
    more_stuff(@friends.size) do |count|
      @friends[0..count]
    end
  end

  def gallery
    more_stuff(@fotos.size) do |count|
      @fotos[0..count].each_with_index.map do |foto, i| 
        (@gallery_array ||= []) << cache(:"gallery_images#{i}"){Helper::picasa_fotos(foto.pictures_url)}
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
  
  def heroku
    render :layout=>false, :text => File.open("#{RAILS_ROOT}/tmp/some_tmp",'a+') {|file| file << "moin"; file.rewind; file.readlines}
  end
end
