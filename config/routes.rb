Basement::Application.routes.draw do
  root to: "home#index"
  get '/sitemap.xml' => 'admin#sitemap', defaults: {format: :xml}

  match '/sitemap.xml' => 'admin#sitemap'

  match ':controller(/:action(/:id(.:format)))'
end