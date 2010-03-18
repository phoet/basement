class FeedItem
  
  def initialize(type, item)
    @type = type
    @item = item
  end
  
  def title
    (@item.title)
  end
  
  def link
    if @type == :atom
      @item.link.first.href
    else
      @item.link
    end
  end
  
  def date
    (@item.pubDate || @item.published)
  end
  
  def text
    (@item.description || @item.content || "").html_safe
  end
  
end