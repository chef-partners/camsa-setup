---
title: automate_dns
parent: Libraries
nav_order: 20
layout: default
---

# automate_dns

This resource is responsible for attempting to register the servers with DNS if the application is deployed as a managed application.

## Syntax

```ruby
automate_dns 'name' do
  verify_url      String    # URL to the central functions for CAMSA
  verify_apikey   String    # API Key associated with the specified URL
  license         String    # Automate license
  subscription_id String    # The Azure subscription ID into which the application has been deployed
  firstname       String    # First name of the user
  lastname        String    # Last name of the user
  fqdn            String    # FQDN set on the machine
  fqdn_pip        String    # FQDN associated with the assigned Public IP address
  creates         String    # Path to file that is created when the registration is successful
  action          Symbol    # defaults to :run if not specified
end
```

where:

 - `automate_dns` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 -  `verify_url`, `verify_apikey`, `license`, `subscription_id`, `firstname`, `lastname`, `fqdn`, `fqdn_pip` and `creates` are properties available to this resource

## Actions

The `automate_dns` resource has the following actions:

`:run` - Attempts to call the central function to register the servers with DNS

