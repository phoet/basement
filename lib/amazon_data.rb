class AmazonData

  def initialize(item)
    @item = item
  end

  def link
    @item.item_links.item_link[2].url.to_s
  end

  def studio
    @item.item_attributes.studio.to_s
  end

  def publication_date
    @item.item_attributes.publication_date.to_s
  end

  def page_count
    @item.item_attributes.number_ofpages.to_s
  end

  def isbn
    @item.item_attributes.isbn.to_s
  end

  def title
    @item.item_attributes.title.to_s
  end

  def authors
    @item.item_attributes.author.map do |a|
      a.to_s
    end
  end

  def thumbnail
    @item.small_image.url.to_s
  rescue
    '/images/dummy.jpg'
  end

  def thumbnail_width
    @item.small_image.width.to_s.to_i
  rescue
    50
  end

  def review
    puts isbn
    content = @item.editorial_reviews.editorial_review.content.to_s
    CGI.unescapeHTML(content)
  rescue
    ''
  end

  def price
    @item.offer_summary.lowest_new_price.formatted_price.to_s
  rescue
    'n/a'
  end

end