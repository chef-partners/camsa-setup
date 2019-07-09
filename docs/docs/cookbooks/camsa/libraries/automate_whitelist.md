---
title: automate_whitelist
parent: Libraries
nav_order: 70
layout: default
---

# automate_whitelist

In order to be able to register with DNS and sent log information to the central Managed App subscription, the Automate license and subscription need to be verified. In order to do this a call is made to the whitelist function which returns a stats to state if this instance of CAMSA is whitelisted or not.


This resource makes use of the `make_request` method in the `camsa_base` resource.

## Syntax

```ruby
automate_whitelist 'name' do
  license           String    # Automate license string
  subscription_id   String    # Azure SUbscription ID of where the app has been deployed
  url               String    # URL to the central functions
  apikey            String    # ApiKey for the specified URL
  action            Symbol    # defaults to :run if not specified
end
```

where:

 - `automate_whitelist` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 - `license`, `license_filename`, `subscription_id`, `password`, `url` and `apikey` are properties available to this resource

## Actions

The `automate_whitelist` resource has the following actions:

`:run` - Call central function to determine if app has been whitelisted

## Defaults

| Property | Default Value |
|---|---|
| license | `node.run_state[:automate][:license]` |
| subscription_id | `node['azure']['metdata']['compute']['subscriptionId']` |
| url | `node['camsa']['azure_functions']['central']['url']` |
| apikey | `node['camsa']['azure_functions']['central']['url']` |

