---
title: chefserver_user
nav_order: 130
parent: Libraries
layout: default
---

Resource to create users on the Chef Server.

Once a user has been created the username and the keys are uploaded to the configuration store.

## Syntax

```ruby
chefserver_user 'name' do
  firstname     String   # Firstname of the user to create
  lastname      String   # Lastname of the user to create
  username      String   # Username if the new account. If not specified the name of the resource will be used
  password      String   # Password to be associated with the user
  emailaddress  String   # EMail address of the user
  url           String   # URL to the instance azure functions
  action        Symbol   # Action to run on the resource, default: create
end
```

where:

  - `chefserver_user` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `firstname`, `lastname`, `username`, `password`, `emailaddress` and `url` are properties of this resource, with the ruby type shown.

## Actions

The `chefserver_user` resource has the following actions:

`:create` - Creates the user

## Defaults

| Property | Default Value |
|---|---|
| url | `node['camsa']['azure_functions']['camsa']['url']` |

