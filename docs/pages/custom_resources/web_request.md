---
title: `web_request` Custom Resource
permalink: custom_resources/web_request.html
---

Although Chef contains a resource called `http_request` it is not easy to specify an alternative CA or certificates to use. Additionally it does not allow the response to be received and made available to other parts of the runlist.

In order to request a trial license (if a license has not been supplied) the SSL files for the local instance of Automate need to be supplied. The recipe also needs to be able to read the response back to get the license from it. The standard `http_request` resource does not allow this. This resource has been written to bypass these issues.

When the resource is used, the response from the endpoint will be placed in the run state object based on the name of the resource. Thus if the resource was called `foobar` the response data would be in `node.run_state[:web_response]['foobar']`.

## Syntax

```ruby
web_request 'name' do
  action        Symbol # Action to run on the resource
  url           String # Url to access
  ssl_verify    String # Whether or not to verify ssl certificates
  message       Hash   # Hash containing the body of the request to send to the Url
  headers       Hash   # A hash of any headers that need to be added to the request
  status_code   Array  # Array of integers for the status codes that are permissible
  content_type  String # Content type to use
  cert_file     String # Path to the certificate file
  key_file      String # Path to the key associated with the specified certificate file
  cacert_file   String # Path to the CA certificate file
end
```

## Parameters

| Name | Type | Description | Default Value |
|---|---|---|---|
| name | String | Name of the resource. This will be used to store the the response | |
| action | Symbol | The action to perform on the end point | :get | 
| ssl_verify | String | Whether to verify SSL certificates | peer |
| message | Hash | Body to pass to the endpoint when the action is a POST | {} |
| headers | Hash | Hash object containing headers that need to be passed to the endpoint | {} |
| status_code | Array | Array of status codes that are permitted that allow the resource to complete without error | [200] |
| content_type | String | Content type to send in the request | application/json |
| cert_file | String | Path to the certificate file to use for authentication | |
| key_file | String | Key file associated with the specified certificate | |
| cacert_file | String | Path to CA file to use | |
