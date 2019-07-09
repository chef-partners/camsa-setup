---
title: camsa_http
nav_order: 100
parent: Libraries
layout: default
---

Although Chef contains a resource called `http_request` it is not easy to specify an alternative CA or certificates to use. Additionally it does not allow the response to be received and made available to other parts of the runlist.

In order to request an Automate trial license (if a license has not been supplied) the SSL files for the local instance of Automate need to be supplied. The recipe also needs to be able to read the response back to get the license from it. The standard `http_request` resource does not allow this. This resource has been written to bypass these issues.

When the resource is used, the response from the endpoint will be placed in the run state object based on the name of the resource. Thus if the resource was called `foobar` the response data would be in `node.run_state[:web_response]['foobar']`.

## Syntax

```ruby
camsa_http 'name' do
  url           String # Url to access
  ssl_verify    String # Whether or not to verify ssl certificates
  message       Hash   # Hash containing the body of the request to send to the Url
  headers       Hash   # A hash of any headers that need to be added to the request
  status_code   Array  # Array of integers for the status codes that are permissible
  content_type  String # Content type to use
  cert_file     String # Path to the certificate file
  key_file      String # Path to the key associated with the specified certificate file
  cacert_file   String # Path to the CA certificate file
  action        Symbol # Action to run on the resource, default: get
end
```

where:

  - `camsa_http` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `url`, `ssl_verify`, `message`, `headers`, `status_codes`, `content_type`, `cert_file`, `key_file` and `cacert_file` are properties of this resource, with the ruby type shown.

## Actions

The `camsa_http` resource has the following actions:

`:get` - Perform an HTTP GET on the specified URL
`:post` - Pefform an HTTP POST on the specified URL

## Defaults

| Property | Default Value |
|---|---|
| message | {} |
| status_codes | [200] |
| headers | {} |
| content_type | application/json |
| ssl_verify | peer |
