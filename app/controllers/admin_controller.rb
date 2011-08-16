class AdminController < ApplicationController

  skip_before_filter :prepare_cache

  def sitemap
    response.headers["Content-Type"] = 'text/xml'
    render layout: false
  end

  def reset_cache
    render text: "reset redis cache: #{cache_store.redis.flushdb}"
  end

end
