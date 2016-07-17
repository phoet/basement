class Picasa < GoogleData

  # id in link like
  # http://picasaweb.google.com/data/entry/base/user/heddahh/albumid/5425173089411226785?alt=json&hl=en_US
  def album_id
    aid = @json["id"]["$t"]
    /\/(\d+)\?/.match(aid)
    $1
  end

  def summary
    @json["summary"]["$t"]
  end

  def url
    @json['link'][1]['href']
  end

  def pictures_url
    @json['link'][0]['href']
  end

  def thumbnail
    @json["media$group"]["media$thumbnail"][0]["url"]
  end

  def picture
    @json["media$group"]["media$thumbnail"][2]["url"]
  end

  def photo_count
    if /Number of Photos in Album: <\/font><font color="#333333">(\d+)<\/font><br\/>/ =~ summary
      $1.to_i
    else
      0
    end
  end

end
