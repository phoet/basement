class WorkController < ApplicationController

  def index; end

  def bookshelf
    more_stuff(@books.size) do |count|
      @books[0..count].map do |book|
        cache(:"book_#{book.asin}"){ Helper::amazon_book(book.asin) }
      end
    end
  end

  def github; end
end
