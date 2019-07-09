---
title: chefserver_org
nav_order: 120
parent: Libraries
layout: default
---

Resource to create an organisation in the CHef Server. It will check to see if the org already exists or not. Additionally when an org is created it will upload the name and the key to the config store.

## Syntax

```ruby
chefserver_org 'name' do
  name          String   # Name of the organisation to create. If not specified the name of the resource will be used
  description   String   # Description of the organisation
  username      String   # Username to be associated with the organisation
  url           String   # URL to the instance azure functions
  action        Symbol   # Action to run on the resource, default: create
end
```

where:

  - `chefserver_org` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `name`, `description`, `username` and `url` are properties of this resource, with the ruby type shown.

## Actions

The `chefserver_org` resource has the following actions:

`:create` - Creates the organisation

## Defaults

| Property | Default Value |
|---|---|
| url | `node['camsa']['azure_functions']['camsa']['url']` |

