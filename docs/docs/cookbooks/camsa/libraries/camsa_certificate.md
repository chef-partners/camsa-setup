---
title: camsa_certificate
parent: Libraries
nav_order: 80
layout: default
---

# camsa_certificate

This resource will attempt to obtain an SSL certificate from the Let's Encrypt service.

It will install the `certbot` command and schedule a script to be run on a cron. This is to ensure that the certificate is always renewed. In order to correctly set this up the resource needs to be supplied with a start and stop command to stop and start necessary services when a certificate is renewed.

THe cron schedule is set from the `node['camsa']['cron']['certificate']` attribute.

## Syntax

```ruby
camsa_certificate 'name' do
  start_command     String    # Command to be run when services need to be started
  stop_command      String    # Command to use to stop the necessary commands
  fqdn              String    # FQDN to be applied to the certificate
  email_address     String    # EMail address to use when requesting the certificate
  schedule          String    # Cron schedule to use
  creates           String    # File to create to denote that th certificate has been created
  action            Symbol    # defaults to :run if not specified
end
```

where:

 - `camsa_certificate` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 - `start_command`, `stop_command`, `fqdn`, `email_address`, `schedule` and `creates` are properties available to this resource

## Actions

The `camsa_certificate` resource has the following actions:

`:run` - Call central function to determine if app has been whitelisted

## Defaults

| Property | Default Value |
|---|---|
| creates | `/usr/local/camsa/flags/certificate.flag` |


