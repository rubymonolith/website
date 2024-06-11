Rails.application.routes.draw do
  namespace :presentations, module: :slides do
    resources :phlex_slides
  end

  sitepress_pages
  sitepress_root
end
