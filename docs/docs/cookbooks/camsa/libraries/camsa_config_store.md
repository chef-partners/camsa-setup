---
title: camsa_config_store
parent: Libraries
nav_order: 90
layout: default
---

During the setup of the servers when the managed app is deployed, a lot of information is generated that the client needs access to.

 - Account passwords
 - Server hostnames
 - IP Addresses
 - Tokens

As has been noted, there are a few functions that are deployed as well and one of these functions accepts data into a configuration store over HTTPS. This custom resource allows the data to be sent to the function of choice.

As this custom resource is in the `common` cookbook, a recipe from the cookbook should be used or a dependency set on it.

## Syntax

```ruby
camsa_config_store 'name' do
  name            String    # Name of the key in config store. If not specified the resource name is used
  url             String    # URL to the azure functions for the deployment
  apikey          String    # ApiKey associated with the URL
  source_file     String    # File from which values to be added to the store should be read
  file_type_hint  String    # Hint for the resource to be able to read the data. It attempt to be determined automatically
  source          Hash      # Hash table of keys and values to add to the store
  http_method     String    # Method to be used when accessing the store
  prefix          String    # Prefix to be applied to the keys when added to the store
  separate        Boolean   # If several items are being sent specify to seperate them out
  action          String    # defaults to :run if not specified
end
```

where:

  - `config_store` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `name`, `url`, `apikey`, `source_file`, `file_type_hint`, `source`, `http_method`, `prefix` and `separate` are properties of this resource, with the ruby type shown.

## Actions

The `camsa_config_store` resource has the following actions:

`:run` - Add the information to the configuration store

## Defaults

| Property | Default Value |
|---|---|
| url | `node['camsa']['azure_functions']['camsa']['url']` |
| apikey | `node['camsa']['azure_functions']['camsa']['apikey']` |
| http_method | POST |
| source | {} |
| separate | false |