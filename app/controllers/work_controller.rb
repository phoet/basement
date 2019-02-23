class WorkController < ApplicationController
  def index; end
  def github; end
  def bookshelf
    more_stuff(@books.size) do |count|
      asins = @books[0..count].map(&:asin)
      cache(:"books_#{asins.join}"){ Helper::amazon_book(asins) }
    end
  end
end
