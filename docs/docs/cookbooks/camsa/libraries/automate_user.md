---
title: automate_user
parent: Libraries
nav_order: 60
layout: default
---

# automate_user

Creates the user in Automate using the information supplied in the attributes.

This resource makes use of the `make_request` method in the `camsa_base` resource.

## Syntax

```ruby
automate_user 'name' do
  firstname         String    # First name of the user to create
  lastname          String    # Last name of the user to create
  username          String    # Username of the user to create. If not sepcified the name will be used.
  password          String    # Password to be assigned to the account
  url               String    # URL to the users API in the local Automate instance
  ssl_verify        String    # One of peer or none to verify the API
  cert_file         String    # Certificate file to use to communicate with the API
  key_file          String    # Certificate key file to use to communicate with the API
  cacert_file       String    # Certificate authority used to create the certificate
  token             String    # Toekn to use to create the user with in Automate
  action            Symbol    # defaults to :create if not specified
end
```

where:

 - `automate_user` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 - `firstname`, `lastname`, `username`, `password`, `url`, `ssl_verify`, `cert_file`, `key_file`, `cacert_file` and `token` are properties available to this resource

## Actions

The `automate_user` resource has the following actions:

`:run` - Attempt to create the user on the Automate server

## Defaults

| Property | Default Value |
|---|---|
| url | https://127.0.0.1/api/v0/auth/users |
| ssl_verify | none |
| cert_file | /hab/svc/deployment-service/data/deployment-service.crtm |
| key_file | /hab/svc/deployment-service/data/deployment-service.key |
| cacert_file | /hab/svc/deployment-service/data/root.crt |

