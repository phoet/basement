Basement::Application.routes.draw do
  root :to => "home#index"
  
  match '/sitemap.xml' => 'home#sitemap'
  match '/interest/curriculum/:type(.:format)' => 'interest#curriculum_pdf'
  match ':controller(/:action(/:id(.:format)))'
end
