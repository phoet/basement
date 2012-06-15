class WorkController < ApplicationController

  def index; end

  def bookshelf
    more_stuff(@books.size) do |count|
      @books[0..count].map do |book|
        data = Helper::amazon_book(book.asin)
        cache(:"book_#{book.asin}"){ [ASIN::SimpleItem.new(JSON.parse(data.raw.to_json))] }.first # fix some wired serialization bug
      end
    end
  end

  def github
    @repos.map do |repo|
      (@commit_hash ||= {})[repo.name] = cache_and_set(:"repo_commits_#{repo.name.gsub(/\W/, '')}") do
        Helper::commit repo.name
      end
    end
    @gists.map do |gist|
      (@gist_files_hash ||= {})[gist.id] = Helper::gist_files gist
    end
  end

end
