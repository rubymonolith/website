Rails.application.routes.draw do
  resources :slides
  sitepress_pages
  sitepress_root
end
