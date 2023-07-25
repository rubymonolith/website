---
title: Authentication
layout: article
---

Monolith wants propel the web towards a future without usernames and passwords. The result can be low operational complexity for customer service, better security for end users, and signups that are more expensive for bots to execute.

Today the most understandable and acceptable way of "Passwordless" authentication is via OAuth with providers like Google, Apple, and Microsoft. One problem with this approach is that it excludes people who don't use these services, so a vendor agnostic login method via email is preferred.

There's a few promising technologies out there, like [Passkeys](https://fidoalliance.org/passkeys/), but unfortunately we live in a world where this will take time for consumers to understand and accept.

## Recommended Approach

Monolith is promoting the user of two key libraries:

* [OmniAuth](https://github.com/omniauth/omniauth) - Integrate "Login with ____" in your Rails applications using OmniAuth
* [NoPassword](https://github.com/rocketshipio/nopassword) - Login via email codes

These two libraries eliminate the need for passwords.
