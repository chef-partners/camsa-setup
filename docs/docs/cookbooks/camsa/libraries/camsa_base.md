---
title: _camsa_base
parent: Libraries
nav_order: 10
layout: default
---

# _camsa_base.rb

As the name implies, this is a base library that is imported by the other usable libs in the cookbook. It is not intended to be called directly in other recipes.

Most of the operations that need to be performed during the setup are HTTP requests. This base library contains methods that allow the configuration and the processing of the request.

## make_request

Perform the HTTP request with the options specified.

### Parameters

| Name | Description | Example | 
|---|---|---|
| method | HTTP method to used | `GET` |
| url | URL to call | http://chef.io |
| status_codes | Array of HTTP codes that are acceptable when determining if the operation was successful | [200] |
| options | Hash table of options such as headers that need to be supplied in the HTTP call | {} |



