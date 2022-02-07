class AdminController < ApplicationController
  skip_before_action :prepare_cache

  def sitemap
    response.headers["Content-Type"] = 'text/xml'
    render layout: false
  end

  def reset_cache
    render plain: "reset redis cache: #{Rails.cache.clear}"
  end
end
