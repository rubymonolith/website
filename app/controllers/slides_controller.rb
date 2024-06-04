require "rouge"

class SlidesController < ApplicationController
  class RougeTailwindTheme < Rouge::Themes::Base16
    name 'tailwind'

    # Define the style mappings
    style Comment,                class: "text-gray-500"
    style Keyword,                class: "text-yellow-300"
    style Literal::String,        class: "text-green-500"
    style Literal::Number,        class: "text-purple-500"
    style Text,                   class: "text-neutral-100"

    style Generic::Output,        class: "text-neutral-100"
    style Generic::Prompt,        class: "text-neutral-100"
    style Generic::Error,         class: "text-red-500"
    style Generic::Traceback,     class: "text-red-500"

    style Name::Constant,         class: "text-purple-400"
    style Name::Function,         class: "text-pink-300"
    style Name::Builtin,          class: "text-neutral-100"
    style Name::Class,            class: "text-pink-400"
    style Name::Variable::Instance, class: "text-sky-300"

    style Name::Decorator,        class: "text-blue-500"
    style Name::Namespace,        class: "text-blue-400"
    style Name::Attribute,        class: "text-blue-400"
    style Name::Entity,           class: "text-blue-400"
    style Name::Tag,              class: "text-blue-400"
    style Name::Property,         class: "text-blue-400"
    style Name::Attribute,        class: "text-blue-400"
    style Name::Function,         class: "text-blue-400"

    style Name::Variable::Global, class: "text-blue-400"

    style Name::Variable::Class,  class: "text-blue-400"
    style Name::Variable::Global, class: "text-blue-400"
    style Name::Variable::Magic,  class: "text-blue-400"
    style Name::Builtin::Pseudo,  class: "text-blue-400"
    style Name::Builtin::Function, class: "text-blue-400"
    style Name::Builtin::Variable, class: "text-blue-400"

    # Add more styles as needed
  end

  class RougeTailwindHTMLFormatter < Rouge::Formatters::HTMLInline
    def safe_span(tok, safe_val)
      return safe_val if tok == Rouge::Token::Tokens::Text

      class_name = @theme.style_for(tok).fetch(:class, nil)

      "<span class=\"#{class_name}\">#{safe_val}</span>"
    end
  end

  class Presentation
    def self.register_layouts(layouts)
      include layouts

      layouts.constants.each do |layout|
        define_method layout do |*args, **kwargs, &block|
          slide = Class.new(self.class.const_get(layout))
          slide.define_method(:template, &block)
          slide.new(*args, **kwargs)
        end
      end
    end
  end

  module Layouts
    class Slide < ApplicationView
      def initialize(title: nil, class: nil, &block)
        @title = title
        @class = binding.local_variable_get(:class)
      end

      def around_template(&)
        VStack(tokens("p-12 h-full", @class), &)
      end

      def Code(language, source)
        pre(class: "bg-gray-800 text-white rounded-2xl p-4") {
          code { format_code(source) }
        }
      end

      def HStack(classes, &)
        div(class: tokens("flex flex-row gap-8", classes), &)
      end

      def VStack(classes, &)
        div(class: tokens("flex flex-col gap-8", classes), &)
      end

      def Title(&)
        h1(class: "font-bold text-4xl", &)
      end

      def Subtitle(&)
        h1(class: "text-4xl", &)
      end

      def Markdown(source)
        div(class: "prose") do
          render inline: source, type: :md
        end
      end

      private
        def format_code(source)
          formatter = RougeTailwindHTMLFormatter.new(RougeTailwindTheme.new)
          lexer = Rouge::Lexers::Ruby.new
          highlighted_code = formatter.format(lexer.lex(source))
          unsafe_raw highlighted_code
        end
    end

    class TitleSlide < Slide
      def Title(&)
        h1(class: "font-bold text-8xl", &)
      end

      def around_template
        super do
          VStack "place-content-center h-full" do
            yield
          end
        end
      end
    end

    class ContentSlide < Slide
      def around_template
        super do
          Title { @title }
          yield
        end
      end
    end
  end

  class PhlexPresentation < Presentation
    register_layouts Layouts

    def slides
      [
        TitleSlide(
          title: "Build Rails Applications with 100% Phlex 💪",
          class: "bg-blue-500 text-white"
        ){
          Title { @title }
          Subtitle { "Phlex is a new way to build Rails applications." }
        },

        ContentSlide(
          title: "What is Phlex?"
        ){
          p { "Phlex is a plain 'ol Ruby object" }
          p { "It's a new way to build Rails applications. Here's what it looks like:" }
          Code :ruby, <<~RUBY
            class MyComponent < Phlex::HTML
              def initialize(name:)
                @name = name
              end

              def view_template
                p { "Hello! #{@name}"}
              end
            end
          RUBY
        },

        ContentSlide(
          title: "Why Phlex?"
        ){
          p { "Build EVERYTHING in Ruby" }
          p { "Simpler API than ViewComponents" }
          p { "Localize view state" }
        },

        ContentSlide(title: "Why Phlex?"){
          Markdown <<~MARKDOWN

          * Because its fun
          * Because its super-de-dooper
          MARKDOWN
        },
      ]
    end
  end

  class SlidesView < ApplicationView
    def initialize(presentation:)
      @presentation = presentation
    end

    def view_template
      ol(class: "grid grid-cols-1 gap-12 p-12 max-w-screen-xl mx-auto") {
        @presentation.slides.each do |slide|
          li(class: "w-full aspect-[16/9] border border-gray-300 rounded-lg overflow-hidden shadow-xl") {
            render slide
          }
        end
      }
    end
  end

  def index
    @presentation = PhlexPresentation.new
    render SlidesView.new(presentation: @presentation)
  end
end
