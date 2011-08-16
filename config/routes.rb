Basement::Application.routes.draw do
  root to: "home#index"

  match '/sitemap.xml' => 'admin#sitemap'

  match ':controller(/:action(/:id(.:format)))'
end
