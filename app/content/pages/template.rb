# Component based-UIs
gem "phlex-rails"
gem "superview"
gem "superform"
gem "supermail"

# Styling
gem "tailwindcss-rails"

# Content management
gem "sitepress-rails"

# Testing
gem "rspec-rails"

# Install dependencies
after_bundle do
  generate "phlex:install"
  generate "supermail:install"
  generate "superform:install"

  generate "sitepress:install"
  generate "markdown_rails:install"

  generate "rspec:install"

  rails_command "tailwindcss:install"

  # Install DaisyUI and Tailwind plugins
  run "npm init -y"
  run "npm install daisyui@latest @tailwindcss/typography@latest"

  # Add sources and plugins to Tailwind CSS
  append_to_file 'app/assets/tailwind/application.css', <<~CSS

    @source "app/content/**/*";
    @source "app/components/**/*";
    @source "app/views/**/*";
    @source "app/controllers/**/*";
    @source "lib/**/*";

    @plugin "@tailwindcss/typography";
    @plugin "daisyui";
  CSS
end
