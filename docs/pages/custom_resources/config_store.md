---
title: `config_store` Custom Resource
permalink: custom_resources/config_store.html
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
config_store 'name' do
  url             String # Uses the name property if not set
  source          Hash   # Hash of key value pairs that need to be stored
  source_file     String # Path to a file that contains the values to send. Supports toml
  file_type_hint  String # If the file does not have an extension to determine file type, a hint can be supplied
  http_method     String # HTTP method to use, defaults to POST
end
```

where:

  - `config_store` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `url`, `source`, `source_file`, `file_type_hint` and `http_method` are properties of this resource, with the ruby type shown.

