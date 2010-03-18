class WorkController < ApplicationController
  def index
  end

  def feed
    more_stuff(@feeds.size) do |count|
      @feeds[0..count].each_with_index.map do |feed, i| 
        (@feed_array ||= []) << cache(:"feed_posts#{i}") do 
          f = Helper::rss_feed(feed.type, feed.url)
          f.nil? ? [] : f.items
        end
        feed
      end
    end
  end

  def bookshelf
    more_stuff(@books.size){|count| @books[0..count].map { |book| p book; Helper::amazon_book(book.asin) } }
  end

  # some fallbacks for searchengine, cause i dont know how to do this better

  def all_books
    redirect_permanently :action=>'index'
  end

  def some_books
    redirect_permanently :action=>'index'
  end

  def prev_feed
    redirect_permanently :action=>'index'
  end

  def next_feed
    redirect_permanently :action=>'index'
  end

  private

  def redirect_permanently(options)  
    headers["Status"] = "301 Moved Permanently"
    redirect_to options
  end
end
