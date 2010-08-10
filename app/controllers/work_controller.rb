class WorkController < ApplicationController
  def index
  end

  def bookshelf
    more_stuff(@books.size) do |count|
      @books[0..count].each_with_index.map do |book, i|
        cache(:"book_#{i}"){[Helper::amazon_book(book.asin)]}.first
      end
    end
  end

  def github
    @repos.each_with_index.map do |repo, i|
      (@commit_array ||= []) << cache_and_set(:"repo_commits#{i}") do
        c = Helper::commits repo.name
        c.nil? ? [] : c.commits
      end
    end
    @gists.each_with_index.map do |gist, i|
      (@gist_files_array ||= []) << cache_and_set(:"gist_files_#{i}") do
        gist.files.map do |file|
          Helper::gist gist.repo, file
        end
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
