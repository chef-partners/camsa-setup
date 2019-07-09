---
title: Recipes
layout: default
nav_order: 35
parent: camsa
---

# Recipes

A number of recipes exist in the cookbook that are used to configure the components of CAMSA.

## backup

Configure the backup script on the servers. It will write out the backup script to disk and then set it as a cronjob to be run each night.

When the cronjob is added the type of backup is passed in, e.g. `-t automate`. This is determined based on the attributes that are set for `node['camsa']['deploy']`.

## certificate

Configures the SSL certificates for the Automate server.

When the recipe is called the resource that is used will install the `certbot` command which is used to obtain ceritficates from Lets Encrypt.

{% include warning.html content="Currently it is not possible to set the certificates for the Chef Server if it is deployed separately to the Automate server" %}

## clean

In order to test the recipes and cookbooks correctly it is often necessary to remove any flag files are that are in `/usr/local/camsa/flags`. This recipe will remove all of these flags so that the recipes run as if they have not been run before.

This recipe is in the Policy File run list and is controlled by the `node['camsa']['clean']` attribute.

{% include warning.html content="This **must** not be used in production. It is intended to be used in development with Test Kitchen" %}

## config_store

Store machine information in the configuration store. For every machine that runs this recipe the following information will be uploaded:

 - Internal IP Address
 - FQDN assigned to the machine
 - FQDN of the Public IP Address assigned to the machine

## datadisks

Format and mount the data disk on the machine.

{% include note.html content="For the moment this only runs on machines where Automate is being deployed" %}

## directories

Create the directories for CAMSA as defined in the [directories]({% link docs/cookbooks/camsa/attributes.md %}#directories.rb) attributes.

## dns

If the deployment is running as a managed application register the machine with the `managedautomate.io` DNS zone.

The recipe calls the [`automate_dns`]({% link docs/cookbooks/camsa/libraries/automate_dns.md %}) resource which verifies the Azure subscription ID and Automate license and if they pass the server will be added to the DNS zone.

## install

This recipe determines what to install based on the `node['camsa']['deploy']` attribute.

For the Chef and Automate servers the Automate package is installed from the `acceptance` channel (until it becomes stable). The chef server is installed using the `--product` switch to the `chef-automate-ctl` command.

This recipe will also be responsible for installing the Chef supermarket, which is currently not being deployed yet.

## kernel

Automate requires some specific kernel settings, this recipe sets these values on the server.

## license

In order operate an Automate server it must ben licensed, either a trial or a full one. This recipe will determine if a full license has been supplied and apply it if it has. However if not a trial license will be obtained and applied to the instance.

The license is made available to other recipes and resources through `node.run_state`.

## monitoring

Configures the monitoring for the deployed components.

Depending on what is being deployed (denoted by `node['camsa]['deploy']`) the monitoring solution will be installed. For example if deploying Chef then Statsd will be installed and the necessary plugin written out.

## tokens

Creates tokens in the Automate server for API access.

Any tokens that are create are uploaded to the configuration store.

As there is no way to detect if a token has already been created on the server, flag file is created in `/usr/local/camsa/flags` for the named token. If the file exist the resource will not be executed.

## user

Create the specified user in the Chef and Automate servers.

The user that was specified will be created in both components. With respect to the Chef server the organisation will also be created.

## whitelist

In order to be able to log to the managed app Log Analytics the workspace and key need to be sought. As these are not embedded into the files in source control, they have to be obtained from the central functions.

When the function is called, the subscription id and the Automate license are passed. If the subscription is whitelisted, e.g. permitted to log, the automate license will be verified. If this passes the function will return the Log Analytics workspace information.