class FeedData
  def initialize(type, feed)
    @type = type
    mash = Mash.new(feed)
    if type == :rdf
      @channel = mash['rdf:RDF'].channel
      @items = mash['rdf:RDF'].item
    elsif type == :atom
      @channel = mash.feed
      @items = @channel.entry
    else
      @channel = mash.rss.channel
      @items = @channel.item
    end
  end

  def title
    puts @channel
    @channel.title
  end

  def link
    if @type == :atom
      @channel.link[1].href
    else
      @channel.link
    end
  end

  def items
    @items.collect do |i|
      FeedItem.new @type, i
    end
  end

end