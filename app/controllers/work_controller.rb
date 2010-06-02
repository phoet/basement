class WorkController < ApplicationController
  def index
  end

  def bookshelf
    more_stuff(@books.size){|count| @books[0..count].map { |book| Helper::amazon_book(book.asin) } }
  end

  def github
    more_stuff(@repos.size) do |count|
      @repos[0..count].each_with_index.map do |repo, i|
        (@commit_array ||= []) << cache(:"repo_commits#{i}") do
          c = Helper::commits repo.name
          c.nil? ? [] : c.commits
        end
        repo
      end
    end
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
