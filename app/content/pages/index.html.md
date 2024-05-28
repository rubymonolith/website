---
title: Build ambitious Rails apps
layout: article
---

<p class="text-xl">
Monolith is a fullstack application development framework built on top of Rails that comes bundled with everything you need that make you an even more productive builder and operator of web applications including a component-first UI framework, a form builder that doesn't need Strong Parameters, a RESTful routing and view helper library, a file based content management system like Middleman, and integration with payment and third-party authorization systems.
</p>

## A great app starts with copy, not code

Before a single line of code is written for an application, you should write about it first. What is it? Why should people use it? How does it work?

```ruby
Article(
  title: "Build ambitious Rails apps",
){
  Hero {
    hgroup {
      h1 { @title }
      h2 { "A great app starts with copy, not code" }
    }
    a(href: "/", class: "btn btn-primary") { "Get started" }
  }
  Markdown %{
    Monolith is a fullstack application development framework built on top of Rails that comes bundled with everything you need that make you an even more productive builder and operator of web applications.

    Here's what you'll love about it:

    1. It's a component-first UI framework
    2. Building apps is productive, fun, and easy
    3. It's built on Phlex, meaning it's highly customizable
  }
}
```

Writing forces you to clarify your thinking of what's really important. It's also the easiest way for anybody to get started.

## Ship it!

Once the landing page is complete its time to ship it! Ruby Monolith uses the `dockerfile-rails` gem to create a Dockerfile that can be deployed to any Docker-ready host, like [Fly.io](https://fly.io).

## Time for the database

After you've shipped your copy and you're ready to start building your application, you add your database.

## Quickly build application UI with Superview

Here's what a typical controller looks like for a blog in Monolith. If you like how productive you feel building Sinatra applications, you'll love how this feels.

```ruby
class PostsController < ApplicationController
  # This little DSL loads @posts from the logged in user.
  assign :posts, from: :current_user

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

When you're satisified with the views, you can move them off to `./app/views/posts/index.rb`, `./app/views/posts/create.rb`, etc. and continue building your application.

## Superform: an absurdly customizable form builder that permits its own parameters

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

## REST easy

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

Remember when REST in Rails was as easy as `link_to "Delete Post", method: :delete` before Hotwire arrived on scene? Don't get me wrong, Hotwire is awesome, but we lost something when UJS was put out to pasture.

Restomatic includes route and view helpers that make REST fun again, so you can do this.

```ruby
create(Post.new)
show(@post, :title)
edit(@post, :title)
delete(@post) { "Delete Post" }
```

## Just say no to passwords

Let's face it: passwords suck. The post-it notes your parents write them on and stick to their phones end up falling off, then they have to run through the password reset rigamrole.

Monolith replaces passwords with email login links, sign-in with Google, Apple, and Microsoft. No, it doesn't use Passkeys because those will always be "just one year away".

And no, it's not OmniAuth. NoPassword implemented OAuth flows in Rails controllers which makes them easier to extend and plug into the `routes.rb` file.

## Upgrade existing Rails apps to Monolith

Monolith is a curated collection of Rails plugins. If you have an existing Rails app, you can upgrade it incrementally, gem-by-gem, and work your way to the productivity of Monolith.

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
