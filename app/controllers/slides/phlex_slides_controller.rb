class Slides::PhlexSlidesController < SlidesController
  class Presentation < Presentation
    def slides
      [
        TitleSlide(
          title: "Build Rails Applications with 100% Phlex 💪",
          subtitle: "A new way of thinking about the front-end in Rails",
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
            * After you try it, half of you will love it and the other half of you will still hate it.
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
        },

        TitleSlide(
          title: "That looks awfully verbose! 😅"
        ),

        ContentSlide(
          title: "Make up for verbosity with abstractions."
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
                render Nav.new do |nav|
                  nav.item("/") { "Home" }
                  nav.item("/about") { "About" }
                  nav.item("/contact") { "Contact" }
                end
              RUBY
            }
          }
        },

        ContentSlide(
          title: "Extend Nav to create a Tailwind navigation"
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
                    Nav do |nav|
                      nav.item("/") { "Home" }
                      nav.item("/about") { "About" }
                      nav.item("/contact") { "Contact" }
                    end
                  }
                end
              end
            RUBY
          }
        },

        ContentSlide(
          title: "Take advantage of Ruby for your templates"
        ){
          Markdown {
            <<~MARKDOWN
            * Use `include` and `extend` in your views.
            * Enforce data types with Ruby's type checking and method signatures.
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
          Code(:ruby, class: "overflow-scroll"){ File.read(__FILE__) }
        },

        ContentSlide(title: "Blog demo"){
          Code(:ruby, class: "overflow-scroll"){ "def hi; puts 'hi'; end;" }
        }
      ]
    end
  end
end