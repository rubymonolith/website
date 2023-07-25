---
title: Say hello to Monolith
layout: article
---

Monolith is a fullstack application development framework built on top of Rails that comes bundled with everything you need that make you a more productive builder and operator of web applications.

It accomplishes this by giving you the content, tools, libraries, and best practices you need that are hand-picked by Rails engineers and who have experience operating SaaS businesses at scale over the past decade.

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