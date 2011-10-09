class Blogger < GoogleData
  
  def content
    @json["content"]["$t"].html_safe
  end
  
  def url
    @json['link'][4]['href']
  end
  
  def comment_count
    if /(\d*) Kommentar/ =~ @json["link"][1]["title"]
      $1.to_i
    else
      0
    end
  end
  
  def comment_link
    @json["link"][1]["href"]
  end
  
end