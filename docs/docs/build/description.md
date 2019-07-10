---
title: Build
layout: default
nav_order: 40
has_children: true
---

# Build

The policy file is packaged up as a Habitat package and then uploaded to the CAMSA origin in the Habitat Depot. The build is performed by running the `habitat/plan.sh` file.

## Local manual build

This can be done on a local Linux machine using the following command, as long as Habitat is installed:

```bash
hab pkg build habitat
```

## Azure DevOps

Project URL: https://dev.azure.com/chefcorp-partnerengineering/camsa

A pipeline file is included with the repo and is located in `build/azure-pipelines.yml`. This file is read by Azure DevOps to perform tests of the cookbook and then run a Habitat package which is then uploaded to the CAMSA origin in the Habitat Depot.

The pipeline process consists of the following steps:

 - Deploy CAMSA functions
 - Install ChefDK
 - Test cookbooks with Test Kitchen
 - Install Habitat
 - Install the Origin Key for the build
 - Build the package
 - Expose the variables from the build to the pipeline
 - Upload the package to Habitat Depot
 - Copy artifact to the artifact directory
 - Upload the artifacts to Azure DevOps
 - Removed CAMSA functions
