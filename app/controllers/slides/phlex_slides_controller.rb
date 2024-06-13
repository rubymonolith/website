class Slides::PhlexSlidesController < SlidesController
  class Presentation < Presentation
    def slides
      [

        TitleSlide(
          title: "Build Rails Applications with 100% Phlex 💪",
          subtitle: "Component-driven front-end development",
          class: "bg-purple-700 text-white"
        ),

        ContentSlide(
          title: "⚠️ WARNING ⚠️",
        ){
          Markdown {
            <<~MARKDOWN
            * What works for me might not work best for you.
            * First look at Phlex and the thought is usually, "that's a terrible idea"
            * It's like Tailwind; you gotta try it.
            * After you try it, half of you will love it and the other half of you will still hate it. 🤣
            MARKDOWN
          }
        },

        TitleSlide(
          title: "Phlex"
        ){
          Title(class: "font-serif") {
            span { @title }
            whitespace
            span(class: "font-light italic") { "/fleks/" }
          }
          Subtitle(class: "font-serif") { "Phlex is a Ruby gem for building fast object-oriented HTML and SVG components. Views are described using Ruby constructs: methods, keyword arguments and blocks, which directly correspond to the output." }
        },

        ContentSlide(
          title: "What does Phlex look like? 👀"
        ){
          p { "Phlex is a plain 'ol Ruby object that can render HTML. Check out this menu implemented in Phlex:" }
          TwoUp {
            VStack {
              Code(:ruby, title: "Here's Phlex"){
                <<~RUBY
                  class Nav < Phlex::HTML
                    def template
                      nav(class: "main-nav") {
                        ul {
                          li { a(href: "/") { "Home" } }
                          li { a(href: "/about") { "About" } }
                          li { a(href: "/contact") { "Contact" } }
                        }
                      }
                    end
                  end
                RUBY
              }
            }

            VStack {
              Code(:html, title: "Here's what it renders"){
                <<~HTML
                  <nav class="main-nav">
                    <ul>
                      <li><a href="/">Home</a></li>
                      <li><a href="/about">About</a></li>
                      <li><a href="/contact">Contact</a></li>
                    </ul>
                  </nav>
                HTML
              }
            }
          }
        },

        ContentSlide(
          title: "Slots are blocks 🧱"
        ){
          Markdown { "The `item` method accepts a block, which is rendered in the navigation `li` component" }
          TwoUp {
            Code(:ruby, title: "Navigation component implementation") {
              <<~RUBY
                class Nav < Phlex::HTML
                  def template(&content)
                    nav(class: "main-nav") { ul(&content) }
                  end

                  def item(url, &content)
                    li { a(href: url, &content) }
                  end
                end
              RUBY
            }

            Code(:ruby, title: "Calling the navigation component"){
              <<~RUBY
                render Nav.new do |it|
                  it.item("/") { "Home" }
                  it.item("/about") { "About" }
                  it.item("/contact") { "Contact" }
                end
              RUBY
            }
          }
        },

        ContentSlide(
          title: "Extend components with inheritence"
        ){
          Markdown { "Useful for shipping a component library or prototyping new features" }
          TwoUp {
            Code(:ruby, title: "Tailwind component") {
              <<~RUBY
                class TailwindNav < Nav
                  def template(&content)
                    nav(class: "flex flex-row gap-4", &content)
                  end

                  def item(url, &content)
                    a(href: url, class: "text-underline", &content)
                  end
                end
              RUBY
            }

            Code(:html, title: "Rendered output"){
              <<~HTML
                <nav class="flex flex-row gap-4">
                  <a href="/" class="text-underline">Home</a>
                  <a href="/about" class="text-underline">About</a>
                  <a href="/contact" class="text-underline">Contact</a>
                </nav>
              HTML
            }
          }
        },

        ContentSlide(
          title: "Set defaults and require values with method signatures"
        ){
          Markdown { "Ruby method signatures enforce required data and sets defaults" }
          TwoUp {
            Code(:ruby, title: "Set default values in arguments"){
              <<~RUBY
                class TailwindNav < Phlex::HTML
                  def initialize(title: "Main Menu")
                    @title = title
                  end

                  def template(&content)
                    h2(class: "font-bold") { @title }
                    nav(class: "flex flex-row gap-4", &content)
                  end

                  def item(url, &content)
                    a(href: url, class: "text-underline", &content)
                  end
                end
              RUBY
            }

            Code(:ruby, title: "Override default method value"){
              <<~RUBY
                render TailwindNav.new title: "Site Menu" do |it|
                  it.item("/") { "Home" }
                  it.item("/about") { "About" }
                  it.item("/contact") { "Contact" }
                end
              RUBY
            }
          }
        },

        ContentSlide(
          title: "Beautiful code with Phlex Kits 🤩"
        ){
          p { "Class functions automatically initialize and render Phlex components" }
          Code(:ruby) {
            <<~RUBY
              class Page < ApplicationComponent
                include Phlex::Kit

                def template
                  Sidebar {
                    Header { "My Site" }
                    TailwindNav title: "Site Menu" do |it|
                      it.item("/") { "Home" }
                      it.item("/about") { "About" }
                      it.item("/contact") { "Contact" }
                    end
                  }
                end
              end
            RUBY
          }
        },

        ContentSlide(
          title: "Do anything with Phlex that you can with Ruby"
        ){
          Markdown {
            <<~MARKDOWN
            * Use `include` and `extend` to mix behaviors into views.
            * Compose views by rendering Phlex views within views.
            * Enforce data types with Ruby's type checking.
            * Distribute UI libraries via RubyGems.
            MARKDOWN
          }
        },

        TitleSlide(
          title: "Using Phlex with Rails",
          subtitle: "Incrementally go from zero 🫣 to hero 🦸"
        ),

        ContentSlide(
          title: "Install the Phlex Rails integration"
        ){
          Prose { "Install the phlex-rails gem:"}
          Code(:sh) {
            <<~SH
              $ gem install phlex-rails
              $ rails g phlex:install
            SH
          }
          Markdown {
            <<~MARKDOWN
            This changes a few things in your Rails project:

            * Adds view paths to `./config/application.rb`.
            * Creates view files in `./app/views` and `./app/views/components`.

            Reboot server to pick-up these changes!
            MARKDOWN
          }
        },

        ContentSlide(
          title: "Render Phlex components from existing templates"
        ){
          Prose { "Phlex components can be rendered from existing Erb, Slim, Haml, or Liquid views."}
          Code(:erb) {
            <<~HTML
              <%= render TailwindNav.new title: "Site Menu" do |it| %>
                <% it.item("/") { "Home" } %>
                <% it.item("/about") { "About" } %>
                <% it.item("/contact") { "Contact" } %>
              <% end %>
            HTML
          }
        },

        ContentSlide(
          title: "Build pages with Phlex"
        ){
          Prose { "Here's what a page might look like in Phlex" }
          Code(:ruby) {
            <<~RUBY
              class Views::Profile < ApplicationComponent
                def initialize(user:)
                  @user = user
                end

                def template
                  div class: "grid grid-cols-2 gap-8" do
                    render TailwindNav.new do |it|
                      it.item("/password") { "Change password" }
                      it.item("/logout") { "Log out" }
                      it.item("/settings") { "Settings" }
                    end

                    main do
                      h1 { "Hi #\{@user.name} "}
                    end
                  end
                end
              end
            RUBY
          }
        },

        ContentSlide(
          title: "Render Phlex pages from controllers"
        ){
          Code(:ruby, title: "Render an instance of a Phlex view from a controller action.") {
            <<~RUBY
              class ProfileController < ApplicationController
                before_action { @user = User.find(params.fetch(:id)) }

                def show
                  respond_to do |format|
                    format.html { render Views::Profile.new(user: @user) }
                  end
                end
              end
            RUBY
          }
        },

        ContentSlide(
          title: "Go all-in on Phlex with Superview"
        ){
          Markdown { "Install the `superview` gem and embed view classes right in the controller."}
          Code(:ruby) {
            <<~RUBY
              class ProfileController < ApplicationController
                before_action { @user = User.find(params.fetch(:id)) }

                include Superview::Actions

                # Rails will map the `show` action to the `Show` class.
                class Show < ApplicationComponent
                  attr_writer :user

                  def template
                    div class: "grid grid-cols-2 gap-8" do
                      render TailwindNav.new do |it|
                        it.item("/password") { "Change password" }
                        it.item("/logout") { "Log out" }
                        it.item("/settings") { "Settings" }
                      end

                      main do
                        h1 { "Hi #\{@user.name} "}
                      end
                    end
                  end
                end
              end
            RUBY
          }
        },

        TitleSlide(
          title: "The amibitious possibilities of Phlex in Rails",
          subtitle: "A few projects that get me excited about the future of Phlex"
        ),

        ContentSlide(
          title: "Superform"
        ){
          Markdown {
            <<~MARKDOWN
            * Build forms with Phlex components.
            * The best form helper that you can use with Rails.
            * You can actually customize it.
            * You don't need strong parameters 🤩.
            MARKDOWN
          }
        },

        ContentSlide(
          title: "Phlex UI & more..."
        ){
          Markdown {
            <<~MARKDOWN
            Entire UI toolkits are being built for Phlex like
            * phlexui
            * ZestUI
            * ...
            MARKDOWN
          }
        },

        TitleSlide(
          title: "What are some websites built with Phlex running in production?"
        ),

        TitleSlide(
          title: "TinyZap⚡️",
        ),

        TitleSlide(
          title: "Thingybase"
        ),

        TitleSlide(
          title: "What are some Phlex projects I can look at?"
        ),

        ContentSlide(title: "This presentation was built with Phlex 🤣"){
          Code(:ruby,
            class: "overflow-scroll",
            file: __FILE__
          )
        },

        ContentSlide(title: "Ruby Monolith Blog Demo: Inline Views"){
          p { "Start building out views in the controller" }
          Code(:ruby,
            class: "overflow-scroll",
            url: "https://raw.githubusercontent.com/rubymonolith/demo/main/app/controllers/blogs_controller.rb"
          )
        },

        ContentSlide(title: "Ruby Monolith Blog Demo: Extracted Views"){
          p { "Then move them into the ./app/views folder" }
          Code(:ruby,
            class: "overflow-scroll",
            url: "https://raw.githubusercontent.com/rubymonolith/demo/main/app/controllers/posts_controller.rb"
          )
        },

        TitleSlide(
          title: "Phlex Dreams 😍",
          subtitle: "Ideas that get me excited about the future of Phlex"
        ),

        ContentSlide(
          title: "Ruby Monolith"
        ){
          Markdown {
            <<~MARKDOWN
            * SaaS starter kit built entirely on Phlex.
            * Lots of batteries included for auth, payments, etc.
            * Most "web problems" would be solved so devs can focus on app problems.
            MARKDOWN
          }
        },

        ContentSlide(
          title: "Site Phlex",
        ){
          p { "Building content pages with Front Matter could look like this:" }
          Code(:ruby){
            <<~RUBY
              # ./app/content/pages/index.phlex.html
              LandingPage(
                title: "Get it now"
              ){
                Hero {
                  Title { @title }
                  Subtitle { "It's the best thing you'll ever get." }
                  button(class: "btn btn-primary") { "Sign up" }
                }
                section {
                  h2 { "Features" }
                  Markdown {
                    <<~MARKDOWN
                    Here's everything you get:

                    * A thing that goes "Ping!"
                    * A bunch of extra batteries
                    * A thing that goes "Boom!"
                    MARKDOWN
                  }
                }
              }
            RUBY
          }
        },

      ]
    end
  end
end