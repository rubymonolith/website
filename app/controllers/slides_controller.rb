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

    # Add more styles as needed
  end

  class RougeTailwindHTMLFormatter < Rouge::Formatters::HTMLInline
    def safe_span(tok, safe_val)
      return safe_val if tok == Rouge::Token::Tokens::Text

      class_name = @theme.style_for(tok).fetch(:class, nil)

      "<span class=\"#{class_name}\">#{safe_val}</span>"
    end
  end

  module Layouts
    class Slide < ApplicationView
      def initialize(title: nil, class: nil, &block)
        @title = title
        @class = kwarg(class:)
      end

      def around_template(&)
        div class: "text-sm sm:text-md md:text-lg lg:text-2xl xl:text-3xl h-full" do
          VStack(class: tokens("p-4 md:p-12 h-full", @class), &)
        end
      end

      def Code(language, class: nil, **, &source)
        pre(class: tokens("text-[0.7rem] md:text-md lg:text-lg xl:text-xl bg-gray-800 text-white rounded-2xl p-2 md:p-4 overflow-auto", class:)) {
          code { format_code(language:, source: source.call) }
        }
      end

      def HStack(class: nil, &)
        div(class: tokens("flex flex-row gap-2 md:gap-8", class:), &)
      end

      def VStack(class: nil, &)
        div(class: tokens("flex flex-col gap-2 md:gap-8", class:), &)
      end

      def Title(class: nil, **, &)
        h1(class: tokens("font-bold text-md xs:text-lg sm:text-3xl md:text-5xl lg:text-6xl leading-tight sm:leading-normal", class:), **, &)
      end

      def Subtitle(&)
        h1(class: "text-md sm:text-xl md:text-3xl lg:text-4xl xl:text-6xl", &)
      end

      def Prose(class: "prose prose-sm sm:prose-md md:prose-xl lg:prose-2xl min-w-fit", &source)
        div(class:, &source)
      end

      def Markdown(class: "prose prose-sm sm:prose-md md:prose-xl lg:prose-2xl min-w-fit", &source)
        Prose { render inline: source.call, type: :md }
      end

      protected
        def kwarg(class:)
          binding.local_variable_get(:class)
        end

        def tokens(*, class: nil, **, &)
          super(kwarg(class:), *, **, &)
        end

        def format_code(language:, source:)
          formatter = RougeTailwindHTMLFormatter.new(RougeTailwindTheme.new)
          lexer = Rouge::Lexer.find(language.to_s)
          highlighted_code = formatter.format(lexer.lex(source))
          unsafe_raw highlighted_code
        end
    end

    class TitleSlide < Slide
      def initialize(*, subtitle: nil, **, &)
        super(*, **, &)
        @subtitle = subtitle
      end

      def Title(**,&)
        super(class: "xl:text-8xl", **, &)
      end

      def template
        Title { @title } if @title
        Subtitle { @subtitle } if @subtitle
      end

      def around_template
        super do
          VStack class: "place-content-center h-full" do
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

  class Presentation
    def self.register_layouts(layouts)
      include layouts

      layouts.constants.each do |layout|
        define_method layout do |*args, **kwargs, &block|
          slide = Class.new(self.class.const_get(layout))
          slide.define_method(:template, &block) if block
          slide.new(*args, **kwargs)
        end
      end
    end

    register_layouts Layouts

    def slides = []

    def slide(index)
      id = Integer(index)
      return nil if id.negative?
      slides.at(id)
    end
  end

  class SlidesView < ApplicationView
    def initialize(presentation:)
      @presentation = presentation
    end

    def view_template
      ol(class: "grid grid-cols-1 gap-4 p-4 md:gap-12 md:p-12 max-w-screen-xl mx-auto") {
        @presentation.slides.each.with_index do |slide, index|
          li {
            a(href: url_for(action: :show, id: index)) {
              render SlideView.new(slide:)
            }
          }
        end
      }
    end
  end

  class SlideView < ApplicationView
    def initialize(slide:)
      @slide = slide
    end

    def view_template
      div(class: "w-full aspect-[16/9] border border-gray-300 rounded-lg overflow-hidden shadow-xl"){
        render @slide
      }
    end
  end

  class SlidePlayerView < ApplicationView
    class BlankSlide < Layouts::Slide
      def template
        VStack {
          h1 { "End of presentation" }
          a(href: url_for(action: :index), class: "underline") { "Go back to Slides" }
        }
      end
    end

    def initialize(presentation:, index:)
      @index = Integer(index)
      @presentation = presentation
      @slide = @presentation.slide(index)
    end

    def slide_url(offset=0)
      index = @index + offset
      # @presentation.slide(index) ? slide_path(index) : nil
      url_for(id: index)
    end

    def view_template
      div class: "w-screen h-screen bg-black flex flex-col justify-center items-center" do
        div(
          class: "w-full aspect-[16/9] bg-neutral-50",
          data: {
            controller: "slide",
            slide_next_value: slide_url(+1),
            slide_previous_value: slide_url(-1),
          },
        ){
          render @slide || BlankSlide.new
        }
      end
    end
  end

  before_action { @presentation = self.class::Presentation.new }

  def index
    render SlidesView.new(presentation: @presentation)
  end

  def show
    render SlidePlayerView.new(presentation: @presentation, index: params.fetch(:id))
  end
end
