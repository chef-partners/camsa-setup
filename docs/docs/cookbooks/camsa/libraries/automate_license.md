---
title: automate_license
parent: Libraries
nav_order: 30
layout: default
---

# automate_license

Once Automate is installed it can be called to create a new trial license if a valid full one has not been supplied. This resource handles this request.

If a trial is required then it will call the local Automate server (which in turn calls the licensing API at Chef) to generate a license. This will be added to the node run_state so it can be used elsewhere in the cookbook.

If a license has been supplied, it is applied to the Automate server and is assigned to the run state.

## Syntax

```ruby
automate_license 'name' do
  url               String    # URL to the license status URL on the local server
  ssl_verify        String    # String used to denote if SSL verification is enabled. Default: none
  cert_file         String    # Path to the deployment service certificate file. See below.
  key_file          String    # Path to the deployment service cerificate key file. See below.
  cacert_file       String    # Path to the Certificate Authority used to sign the above certificate. See below/
  license           String    # License string for Automate
  license_filename  String    # Path to the file on disk containing the license text
  trial_url         String    # URL to the local machine to request the license from. See below.
  first_name        String    # First name of the user requesting the license
  last_name         String    # Last name of the user requesting the license
  email             String    # Email address associated with the specified user
  gdpr_agree        String    # Boolean stating if consent to GDPR
  action            Symbol    # defaults to :apply if not specified
end
```

where:

 - `automate_license` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 - `url`, `ssl_verify`, `cert_file`, `key_file`, `cacert_file`, `license`, `license_filename`, `trial_url`, `first_name`, `last_name`, `email` and `gdpr_agree` are properties available to this resource

## Actions

The `automate_dns` resource has the following actions:

`:apply` - Attempt to apply the specified license or request a trial license

## Notes

When communicating with the Automate server, it is done using a specific URL and SSL certificate files. These files are deployed by Automate when it is installed, however a specific host needs to be used when requesting license details.

When the Automate server is deployed an entry is added to the `/etc/hosts` file thus:

```
127.0.0.1 automate-gateway
```

By doing this the certificate files can be used to create a secure connection to the local server.

