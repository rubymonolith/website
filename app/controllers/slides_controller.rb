class SlidesController < ApplicationController
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
      def initialize(title: nil, &block)
        @title = title
      end

      def around_template(&)
        VStack("p-8 h-full", &)
      end

      def Code(language, source)
        pre(class: "bg-gray-800 text-white rounded p-4") {
          code { source }
        }
      end

      def HStack(classes, &)
        div(class: tokens("flex flex-row gap-8", classes), &)
      end

      def VStack(classes, &)
        div(class: tokens("flex flex-col gap-8", classes), &)
      end
    end

    class TitleSlide < Slide
      def around_template
        super do
          VStack "place-content-center h-full" do
            h1(class: "font-bold text-6xl") { @title }
            yield
          end
        end
      end
    end

    class ContentSlide < Slide
      def around_template
        super do
          h1(class: "font-bold text-3xl") { @title }
          yield
        end
      end
    end
  end

  class PhlexPresentation < Presentation
    register_layouts Layouts

    def slides
      [
        TitleSlide(title: "Build Rails Applications with 100% Phlex"){
          h2(class: "text-4xl") { "Phlex is a new way to build Rails applications." }
        },

        ContentSlide(title: "What is Phlex?"){
          p { "Phlex is a plain 'ol Ruby object" }
          p { "It's a new way to build Rails applications. Here's what it looks like:" }
          Code :ruby, <<~RUBY
            class MyComponent < Phlex::Component
              def initialize(name:)
                @name = name
              end

              def view_template
                p { "Hello! #{@name}"}
              end
            end
          RUBY
        },

        ContentSlide(title: "Why Phlex?"){
          p { "Build EVERYTHING in Ruby" }
          p { "Simpler API than ViewComponents" }
          p { "Localize view state" }
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
          li(class: "w-full aspect-[16/9] border border-gray-300 rounded-lg p-4 shadow-xl") {
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
