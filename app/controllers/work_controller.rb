class WorkController < ApplicationController

  def index; end

  def bookshelf
    more_stuff(@books.size) do |count|
      @books[0..count].map do |book|
        cache(:"book_#{book.asin}"){ [Helper::amazon_book(book.asin)] }.first
      end
    end
  end

  def github
    @repos.map do |repo|
      (@commit_hash ||= {})[repo.name] = cache_and_set(:"repo_commits_#{repo.name.gsub(/\W/, '')}") do
        c = Helper::commits repo.name
        c.nil? ? [] : c.commits
      end
    end
    @gists.map do |gist|
      (@gist_files_hash ||= {})[gist.repo] = cache_and_set(:"gist_files_#{gist.repo}") do
        gist.files.map do |file|
          Helper::gist gist.repo, file
        end
      end
    end
  end

end
