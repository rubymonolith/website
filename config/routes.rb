Rails.application.routes.draw do
  namespace :presentations, module: :slides do
    resources :phlex_slides
  end

  resources :gems do
    member do
      get :homepage
      get :documentation
      get :docs, to: "gems#documentation"
      get :changes
      get :changelog, to: "gems#changes"
      get :versions
      get :source_code
      get :source, to: "gems#source_code"
      get :bug_tracker
      get :bugs, to: "gems#bug_tracker"
      get :issues, to: "gems#bug_tracker"
      get :mailing_list
      get :wiki
      get :funding
      get :project
      get :gem
    end
  end

  sitepress_pages
  sitepress_root
end
