---
title: Build ambitious Rails apps
layout: article
---

Monolith is a fullstack application development framework built on top of Rails that comes bundled with everything you need that make you an even more productive builder and operator of web applications.

## Components all the way down

Here's what a typical controller looks like for a blog in Monolith. If you like how productive you feel building Sinatra applications, you'll love how this feels.

```ruby
class PostsController < ApplicationController
  # This little DSL loads @posts from the logged in user.
  resources :posts, from: :current_user

  # Forms are concise, expressive, and highly customizable
  # Phlex components.
  class Form < ApplicationForm
    def template
      labeled field(:title).input.focus
      labeled field(:publish_at).input
      labeled field(:content).textarea(rows: 6)

      submit
    end
  end

  # View names correspond with what you'd expect from Rails resources.
  class Index < ApplicationView
    attr_writer :posts, :current_user

    def title = "#{@current_user.name}'s Posts"

    def template
      # Tables can be abstracted away into components.
      render TableComponent.new(items: @posts) do |table|
        table.column("Title") { show(_1, :title) }
        table.column do |column|
          column.title do
            link_to(user_blogs_path(@current_user)) { "Blogs" }
          end
          column.item { show(_1.blog, :title) }
        end
      end
    end
  end

  class Show < ApplicationView
    attr_writer :post

    # Method names can be defined in subclasses, like title, that are
    # picked up by the layout superclass to use in the HTML title tags
    # or other areas outside of the view.
    def title = @post.title
    def subtitle = show(@post.blog, :title)

    def template
      table do
        tbody do
          tr do
            th { "Status" }
            td { @post.status }
          end
          tr do
            th { "Publish at" }
            td { @post.publish_at&.to_formatted_s(:long) }
          end
          tr do
            th { "Content" }
            td do
              article { @post.content }
            end
          end
        end
      end
      nav do
        # Concicse link helpers bring sanity back to RESTful Rails applications.
        edit(@post, role: "button")
        delete(@post)
      end
    end
  end

  class Edit < ApplicationView
    attr_writer :post

    def title = @post.title
    def subtitle = show(@post.blog, :title)

    def template
      render Form.new(@post)
    end
  end

  private
    def destroyed_url
      @post.blog
    end
end
```

## Superform: an absurdly customizable form builder that permits its own params

The adage is that if you want to build great web apps, you need to get really good at working with forms.

Superforms makes that possible so you can create concise forms like this:

```ruby
class Form < TailwindForm
  def template
    group "Post" do
      labeled field(:title).input.focus
      labeled field(:content).textarea(rows: 6)
    end

    labeled field(:publish_at).input

    submit "Save Post"
  end
end
```

And customize everything beneath it like this:

```ruby
class TailwindForm < ApplicationForm
  def labeled(component)
    div "p-4" do
      render component.field.label
      render component
    end
  end

  def group(title)
    fieldset "p-8" do
      legend { title }
      yield
    end
  end

  def submit(text)
    input(type: "submit", value: "text")
  end
end
```

The best part? You don't have to jump around between templates, form builder objects, and configuration files. It's all in one spot.

Actually that's not the best part. **Superform doesn't need Strong Parameters**, which is one less thing you have to worry about when you're building your apps.

## Built-in content management with the power of Jeckyll

Remember the good 'ol days when building a website was as simple as editing a few HTML pages? Monolith brings that simplicity back by bundling Sitepress, a powerful file-backed content management system, in Rails.

When you spin up your first Monolith app, just edit `index.html` with whatever content you want.

```md
---
title: Welcome to Monolith
---

<p>Monolith makes it easy to build ambitous websites.</p>

<%= link_to new_user_path %>
```

As your app gets more sophisticated, so will your content needs. Add a support website by just putting Markdown files in `./app/content/pages/support/**/*.md.erb`, then access it from your Application with one-liners as simple as `SupportPage.find(tags: %w[login passwords])`

Announce updates to your web app with a blog at `./app/content/pages/blog/*.html.md` and show this inside your app via `BlogPoagePage.all.sort_by(&:date).take(10)`.

## The RESTful API-less API

Thinking about building a JSON or GraphQL API for your application? Don't. You don't need it.

Instead, if you build your application with Superform and Restomatic, you'll get a pretty good API without all the overhead of maintaining an API.

Here's what your `config/routes.rb` looks like:

```ruby
Rails.application.routes.draw do
  resources :users, except: :destroy do
    nest :blogs
    create :session
  end

  resources :blogs do
    nest :posts do
      batch :delete, :publish, :unpublish
    end
  end

  resources :posts

  resources :sessions

  root to: "blogs#index"
end
```

## Just say no to passwords

Let's face it: passwords suck. The post-it notes your parents write them on and stick to their phones end up falling off, then they have to run through the password reset rigamrole.

Monolith replaces passwords with email login links, sign-in with Google, Apple, and Microsoft. No, it doesn't use Passkeys because those will always be "just one year away".

## Upgrade existing Rails apps to Monolith

All of Monolith

## Getting started

Install the Ruby Monolith gem.

```sh
gem install rubymonolith
```

Then create and launch new Monolith project.

```sh
monolith new my-first-app
cd my-first-app
bin/dev
```

This will create a Rails project, add Monolith to it, switch to the project directory, and boot the server. Just open the URL displayed on your console in the browser and it's off to the races!

### Existing Rails apps

If you're adding Monolith to an existing Rails app, add the gem.

```sh
bundle add monolith
```

Then run the installer.

```sh
rails g monolith:install
```

That's it!

## Why monolith?

Monolith is a curated collection of libraries and methods that optimize for low operational complexity. What does that mean exactly?

1. **Component-driven scaffolding** - Rails code generation is easy at first, but it can become hard to change as future requirements change. Monolith takes a "components first" approach to building UIs with object-oriented Phlex components. Instead of worrying about markup, templates, & partials, you can build powerful UI abstractions with components that will compound your efforts over time.

2. **Low customer service requirements** - The people behind Monolith have experience opearting SaaS applications and know the areas that waste a lot of customer service time and energy like password resets, adding people to accounts, etc.

3. **Best practices from the start** - Libraries like Devise make authentication seem as simple as entering a username and password, but as your application grows in complexity and requires sign-on from Google, Apple, or enterprises, you'll quickly find your default Devise setup needs to be rearchitected.

## Source code

Monolith source code is [available on Github](https://github.com/rubymonolith)