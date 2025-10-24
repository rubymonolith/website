---
title: Superform
layout: article
---

Super Forms streamlines the development of forms on Rails applications by making everything a component.

Here's what a SuperForm looks in your Erb.

```erb
<%= render ApplicationForm.new model: @user do
  render field(:email).input(type: :email)
  render field(:name).input

  button(type: :submit) { "Sign up" }
end %>
```

That's very spartan though, let's add labels and HTML between each form row so we have something to work with.

```erb
<%= render ApplicationForm.new do
  div class: "form-row" do
    render field(:email).label
    render field(:email).input(type: :email)
  end
  div class: "form-row" do
    render field(:name).label
    render field(:name).input
  end

  button(type: :submit) { "Sign up" }
%>
```

Well jeepers! That's starting to get verbose. Let's add some helpers to ApplicationForm and tighten things up.

## Customizing forms

SuperForms are built entirely out of Phlex components. The method names correspeond with the tag, its arguments are attributes, and the blocks are the contents of the element.

```ruby
class ApplicationForm < SuperForm::Base
  class MyInputComponent < ApplicationComponent
    def view_template(&)
      div class: "form-field" do
        input(**attributes)
        if field.errors?
          p(class: "form-field-error") { field.errors.to_sentence }
        end
      end
    end
  end

  class Field < Field
    def input(**attributes)
      MyInputComponent.new(self, attributes: attributes)
    end
  end

  def labeled(component)
    div class: "form-row" do
      render component.field.label
      render component
    end
  end

  def submit(text)
    button(type: :submit) { text }
  end
end
```

That looks like a LOT of code, and it is, but look at how easy it is to create forms.

```erb
<%= render ApplicationForm.new model: @user do
  labeled field(:name).input
  labeled field(:email).input(type: :email)

  submit "Sign up"
end %>
```

Much better!

## Forms can be extended

The best part? If you have forms with a completely different look and feel, you can extend the forms just like you would a Ruby class:

```ruby
class AdminForm < ApplicationForm
  class AdminInput < ApplicationComponent
    def view_template(&)
      input(**attributes)
      small { admin_tool_tip_for field.key }
    end
  end

  class Field < Field
    def tooltip_input(**attributes)
      AdminInput.new(self, attributes: attributes)
    end
  end
end
```

Then, just like you did in your Erb, you create the form:

```erb
<%= render AdminForm.new model: @user do
  labeled field(:name).tooltip_input
  labeled field(:email).tooltip_input(type: :email)

  submit "Save"
end %>
```

## Self-permitting Parameters

Guess what? It also permits form fields for you in your controller, like this:

```ruby
class UserController < ApplicationController
  # Your actions

  private

  def permitted_params
    @form.permit params
  end
end
```

To do that though you need to move the form into your controller, which is pretty easy:

```ruby
class UserController < ApplicationController
  class Form < ApplicationForm
    render field(:email).input(type: :email)
    render field(:name).input

    button(type: :submit) { "Sign up" }
  end

  before_action :assign_form

  # Your actions

  private

  def assign_form
    @form = Form.new(model: @user)
  end

  def permitted_params
    @form.permit params
  end
end
```

Then render it from your Erb in less lines, like this:

```
<%= render @form %>
```
