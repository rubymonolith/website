---
title: Content Management
layout: article
---

One of the most overlooked aspects of building Rails applications today is the content management system. Monolith thinks this part is absolutely key to a great product, and should be the first thing that's shipped to a website so that builders can write about what they're going to build before they build it.

## Recommended Approach

Monolith recommends using [Sitepress](https://sitepress.cc) to create and manage content. Since it manages content as files in the `./app/content` directory of your Rails app, its really easy to create marketing, landinag pages, customer support, and terms of service content while keeping complexity and dependencies to a minimum.

