---
title: automate_ssl
parent: Libraries
nav_order: 40
layout: default
---

# automate_ssl

Resource responsible for patching the Automate server with the SSL certificate and key. This works in conjunction with a supplied certificate and Let's Encrypt.

It will create a patch file with the certificate and key and then run the `chef-automate config patch <FILE>` command to set the certificate on the Automate server.

## Syntax

```ruby
automate_license 'name' do
  cert_path         String    # Path to the certificate file to read
  cert_key_path     String    # Path to the certificate key file to read
  patch_file        String    # The name of hte file to create the file to patch Automate with
  template          String    # Template file to use to create the patch file
  action            Symbol    # defaults to :run if not specified
end
```

where:

 - `automate_ssl` is the resource
 - `name` is the name given to the resource block
 - `action` identifies which steps chef-client will take to bring the nodes into the desired state
 - `url`, `ssl_verify`, `cert_file`, `key_file`, `cacert_file`, `license`, `license_filename`, `trial_url`, `first_name`, `last_name`, `email` and `gdpr_agree` are properties available to this resource

## Actions

The `automate_ssl` resource has the following actions:

`:run` - Run the patch operation to set the certificate and key on the Automate instance

## Defaults

| Property | Default Value |
|---|---|
| cert_path | /etc/letsencrypt/live/%s/fullchain.pem |
| cert_key_path | /etc/letsencrypt/live/%s/privkey.pem |
| patch_file | /usr/local/camsa/etc/patch_ssl.toml |
| template | patch_ssl.toml |

The paths to the certificate and certificate key are patched with string formatting using the `node['fqdn']` attribute.

