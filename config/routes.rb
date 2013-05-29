Basement::Application.routes.draw do
  get '/sitemap.xml' => 'admin#sitemap', defaults: {format: :xml}
  get '/admin/reset_cache' => 'admin#reset_cache'

  Helper::menu.each do |item|
    get "/#{item.id}"  => "#{item.id}#index"
    item.subitems.each do |subitem|
      get "/#{item.id}/#{subitem.id}"  => "#{item.id}##{subitem.id}"
    end
  end

  root to: 'home#index'
end
