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
          Markdown(class: "prose-lg") {
            <<~MARKDOWN
            * What works for me might not work best for you.
            * First look at Phlex and the thought is usually, "that's a terrible idea"
            * It's like Tailwind; you gotta try it.
            * After you try it, half of you will love it and the other half of you will still hate it.
            MARKDOWN
          }
        },

        ContentSlide(
          title: "What is Phlex?"
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
          title: "Actually no... sorry, I got sidetracked building tools",
          subtitle: "Let's talk about that instead",
          class: "text-lg bg-neutral-800 text-neutral-200"
        ),

        ContentSlide(
          title: "Why Phlex?"
        ){
          p { "Build EVERYTHING in Ruby" }
          p { "Simpler API than ViewComponents" }
          p { "Localize view state" }
        },

        ContentSlide(title: "Why Phlex?"){
          Markdown(class: "prose prose-neutral-100"){
            <<~MARKDOWN
            * **,ecause its fun
            * Because its super-de-dooper
            MARKDOWN
          }
        },

        ContentSlide(title: "Here's what this presentation looks like"){
          Code(:ruby, class: "overflow-scroll"){ File.read(__FILE__) }
        }
      ]
    end
  end
end