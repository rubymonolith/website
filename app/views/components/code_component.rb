require "rouge"

class CodeComponent < ApplicationComponent
  module Tailwind
    class Theme < Rouge::Themes::Base16
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

    class HTMLFormatter < Rouge::Formatters::HTMLInline
      def safe_span(tok, safe_val)
        return safe_val if tok == Rouge::Token::Tokens::Text

        class_name = @theme.style_for(tok).fetch(:class, nil)

        "<span class=\"#{class_name}\">#{safe_val}</span>"
      end
    end

    FORMATTER = HTMLFormatter.new(Theme.new)

    def self.format_code(language:, source:, formatter: FORMATTER)
      lexer = Rouge::Lexer.find(language.to_s)
      formatter.format(lexer.lex(source))
    end
  end

  def initialize(source:, language:)
    @source = source
    @language = language
  end

  def template
    code { unsafe_raw Tailwind.format_code(language: @language, source: @source) }
  end
end
