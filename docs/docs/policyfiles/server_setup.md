---
title: server_setup
layout: default
nav_order: 10
parent: Policy Files
---

# server_setup

This is the main policy file for the setup of the Chef components in CAMSA.

## Dependencies

There are a number of dependencies for the recipes in the cookbooks which are defined in the policy file.

```ruby
cookbook 'nodejs', '~> 6.0', :supermarket
cookbook 'line', '~> 2.2.0', :supermarket
cookbook 'filesystem', '~> 1.0.0', :supermarket
```

## Run list

The recipes that are called by policy file are:

```ruby
run_list [
  'camsa::config_store',
  'camsa::datadisks',
  'camsa::directories',
  'camsa::clean',
  'camsa::kernel',
  'camsa::install',
  'camsa::license',
  'camsa::tokens',
  'camsa::user',
  'camsa::whitelist',
  'camsa::monitoring',
  'camsa::backup',
  'camsa::dns',
  'camsa::certificate',
]
```