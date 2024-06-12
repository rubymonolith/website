class Slides::PhlexSlidesController < SlidesController
  class Presentation < Presentation
    def slides
      [
        TitleSlide(
          title: "Build Rails Applications with 100% Phlex 💪",
          subtitle: "Component-driven front-end development",
          class: "bg-blue-700 text-white"
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
          title: "What is Phlex?",
          subtitle: "Phlex is a Ruby gem for building fast object-oriented HTML and SVG components. Views are described using Ruby constructs: methods, keyword arguments and blocks, which directly correspond to the output."
        ),

        ContentSlide(
          title: "What does Phlex look like?"
        ){
          p { "Phlex is a plain 'ol Ruby object that can render HTML. Check out this menu implemented in Phlex:" }
          HStack {
            VStack {
              p(class: "font-bold") { "Here's Phlex" }
              Code(:ruby){
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
              p(class: "font-bold") { "Here's the HTML it renders" }
              Code(:html){
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

        TitleSlide(
          title: "That looks awfully verbose! 😅"
        ),

        ContentSlide(
          title: "Phlex get's less verbose when you start building up a component library"
        ){
          p { "The Navigation Menu was refactored such that the dev doesn't need to worry about the item implementation" }
          HStack {
            Code(:ruby) {
              <<~RUBY
                class Nav < Phlex::HTML
                  def template(&content)
                    nav(class: "main-nav") {
                      ul(&content)
                    }
                  end

                  def item(url, &content)
                    li { a(href: url, &content) }
                  end
                end
              RUBY
            }

            Code(:ruby){
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
          title: "Phlex makes creating abstractions easy since it's just Ruby"
        ){
          p { "Useful if you're shipping a component library or prototyping new features" }
          VStack {
            Code(:ruby) {
              <<~RUBY
                class TailwindNav < Nav
                  def template(&content) = nav(class: "flex flex-row gap-4", &content)

                  def item(url, &content)
                    a(href: url, class: "text-underline", &content)
                  end
                end
              RUBY
            }

            Code(:html){
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
          title: "And then there's Kits 🤩"
        ){
          p { "Class functions will automatically initialize and render your components" }
          Code(:ruby) {
            <<~RUBY
              class Page < ApplicationComponent
                def template
                  Sidebar {
                    Header { "My Site" }
                    TailwindNav do |it|
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
          title: "Take fill advantage of Ruby for view templates"
        ){
          Markdown {
            <<~MARKDOWN
            * Use `include` and `extend` to mix behaviors into views.
            * Compose views by rendering other views.
            * Enforce data types with Ruby's method signatures & type checking.
            * Distribute UI libraries via RubyGems.
            MARKDOWN
          }
        },

        TitleSlide(
          title: "Phlex makes possible an ambitious future of libraries that plug into each other..."
        ),

        ContentSlide(
          title: "Superview"
        ){
          Markdown {
            <<~MARKDOWN
            * Embed Phlex views right into controllers.
            * Sinatra like ergonomics for Rails.
            MARKDOWN
          }
        },

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

        ContentSlide(
          title: "Try Phlex today!"
        ){
          Markdown {
            <<~MARKDOWN
            Try it in Rails:

            ```ruby
            $ gem install phlex-rails
            $ rails g phlex:install
            ```

            Then head to Phlex.fun to learn more!
            MARKDOWN
          }
        }

      ]
    end
  end
end