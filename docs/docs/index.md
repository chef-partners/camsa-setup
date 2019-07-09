---
title: Overview
permalink: /
nav_order: 1
layout: default
---

# Overview

The Chef Automate Managed Service for Azure (CAMSA) consists of 2 servers:

  1. Automate Server with integrated Chef Server
  3. Supermarket Server (optional)

Each of these machines starts off as a vanilla Ubuntu machine deployed from the Azure Marketplace. Therefore each one needs to be configured to operate in its intended role. To achieve this the Chef Effortless pattern is used. The [github.com/chef-partners/camsa-setup](https://github.com/chef-partners/camsa-setup) repository contains all of the cookbooks and Policy file definitions to create the Habitat packages for each server.

## Conventions

There are a number of conventions in use in the cookbook.

| Convention | Description |
|----|----|
| _ | If a recipe, library or resource is prefixed with an underscore `_`, then it is not intended to be called directly. It is a private resource that will be used by the other components in the cookbook |