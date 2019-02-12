---
title: Attributes
permalink: attributes.html
---

As with any `chef-client` run there are a number of attributes that are configured to assist with the setup of the server software in CAMSA.

Some of the attributes are required to be supplied when the client is run for the first time. The table below shows the attributes that must be supplied.

| Attribute | Description | Example |
|---|---|---|
| `camsa.license` | If the client already has a license it should be specified here, if not then it should be left empty | '' |
| `camsa.firstname` | First name of the new account to create on the servers | Russell |
| `camsa.lastname` | Last name of the account | Seymour |
| `camsa.emailaddress` | Email address to be associated with the newly created account | rseymour@chef.io |
| `camsa.gdpr` | State that the client is happy for Chef to store some details and to be contacted | true |
