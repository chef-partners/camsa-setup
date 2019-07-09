---
title: Attributes
layout: default
nav_order: 10
parent: camsa
---

# Attributes

There are a lot of attributes in the cookbook. To make management easier they have been split across several files. The following table shows these attributes, what they are used for and the file that can be found in.

A lot of the attributes are derived from the host on which the cookbook is run, for example metadata from the Azure instance. This means that there are only a few that have to be set when testing or deploying the system. The ones that need to be specified are highlighted in the table.

## automate.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.automate.tokens` | Array of names of tokens that should be created in the Automate server | `['user_automate_token']` | |
| `camsa.automate.kernel."vm.max_map_count"` | | 262144 | |
| `camsa.automate.kernel."vm.dirty_expire_centisecs"` | | 20000 | |
| `camsa.automate.download.channel` | Channel from which the Automate package should be downloaded | current | |
| `camsa.automate.download.url` | The URL from which the package will be downloaded. This channel is substituted into the string at run time | https://packages.chef.io/files/%s/automate/latest/chef-automate_linux_amd64.zip | |
| `camsa.automate.command.location` | Location of the `chef-automate` command once installed | `/usr/local/bin/chef-automate` | |
| `camsa.automate.certs.cert` | Path to the deployment service certificate | `/hab/svc/deployment-service/data/deployment-service.crt` | |
| `camsa.automate.certs.key` | Path to the deployment service certificate key | `/hab/svc/deployment-service/data/deployment-service.key` | |
| `camsa.automate.certs.cacert` | Path to the Certificate Authority which signed the deployment service certificate | `/hab/svc/deployment-service/data/cacert.crt` | |
| `camsa.automate.license` | The automate license. This can be supplied if a license has already been obtained. If not  a trial one will be generated and assigned. | |

## azure_functions.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.azure_functions.camsa.url` | URL to the functions that have been deployed as a part of CAMSA. This will be supplied by the ARM template | '' | * |
| `camsa.azure_functions.camsa.apikey` | ApiKey that belongs to the specified URL. This will be supplied by the ARM template | '' | * |
| `camsa.azure_functsion.central.url` | URL to the central functions for management. This will only be populated if deployed as a Managed Application | '' | |
| `camsa.azure_functions.central.apikey` | ApiKey for the specified central functions URL. This will only be populated if deployed as a Managed Application | '' | |
| `camsa.monitoring.automate.function.name` | Name of the function endpoint to use to send the Automate statistics. Will be supplied by the ARM template | `AutomateLog` | | 

## chefserver.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.chefserver.user.statsd` | User that should be created for the Statsd service | `statsd` | |
| `camsa.chefserver.npm.packages` | Hash table of packages that need to be installed to monitor the chef server statistics. See below for the packages. | {} | |

The following table shows the NPM Packages that are installed, what they are for and the options being used.

| Package Name | Version | Option | Description |
|---|---|---|---|
| statsd | 0.8.0 | -g | Statsd server to receive statistics from the the Chef Server |
| azure-storage | | -g | Library to allow files to be uploaded to Azure Storage | 
| sprintf-js | | -g | Library to allow formatting of strings within Javascript |

# clean.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.clean` | When testing it is useful to be able to delete the flags that are generated to make things idempotent. | false | |

# config_store.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.config_store.items.automate.automate_fqdn` | FQDN of the automate server. This is set by the template. | node['fqdn] | |
| `camsa.config_store.items.automate.pip_automate_fqdn` | FQDN that is assigned to the Public IP in Azure. This will be retrieved by the default recipe | | |
| `camsa.config_store.items.automate.automate_internal_ip` | Internal IP address of the automate server | node['azure']['metadata']['network']['local_ipv4'][0] | |
| `camsa.config_store.items.chef.chef_fqdn` | FQDN of the chef server. This is set by the template. | node['fqdn] | |
| `camsa.config_store.items.chef.pip_chef_fqdn` | FQDN that is assigned to the Public IP in Azure. This will be retrieved by the default recipe | | |
| `camsa.config_store.items.chef.chef_internal_ip` | Internal IP address of the chef server | node['azure']['metadata']['network']['local_ipv4'][0] | |
| `camsa.config_store.items.supermarket.supermarket_fqdn` | FQDN of the automate server. This is set by the template. | node['fqdn] | |
| `camsa.config_store.items.supermarket.pip_supermarket_fqdn` | FQDN that is assigned to the Public IP in Azure. This will be retrieved by the default recipe | | |
| `camsa.config_store.items.supermarket.supermarkete_internal_ip` | Internal IP address of the automate server | node['azure']['metadata']['network']['local_ipv4'][0] | |

## cron.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.cron.backup` | Cron string stating when the backup should be run | `0 1 * * *` | |
| `camsa.cron.certficate` | String stating when the certificate renew should occur | `30 0 * * *` | |

## datadisks.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.datadisks.automate` | Array of hashes describing what device to format and where to mount it on the machine | See below | |

Each hash in the array can have the following settings. The example values show the default for the automate datadisks.

| Name | Description | Value |
|---|---|---|
| label | Label to applied to the partition when it is formatted | AutomateDisk |
| fstype | The type of file system | ext4 |
| device | The device on which to create the partition | /dev/sdc |
| mount | Where the device should be mounted | /hab |

## default.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.managed_app` | State if the deployment is managed or not. By default it is not. If set to true a check will be made to ensure it is authorised to be a managed app | true | | 
| `camsa.deploy.automate` | State if automate should be deployed or not | true | |
| `camsa.deploy.chef` | State if chef should be deployed or not | true | |
| `camsa.deploy.supermarket` | State if supermarket should be deployed or not | true | |
| `camsa.debug` | Specify if extra information should be output in the logs | false | |
| `camsa.firstname` | First name of the account to create on the Chef components | | * |
| `camsa.lastname` | Last name of the account to create on the Chef components | | * |
| `camsa.username` | Username of the account to create on the Chef components | | * |
| `camsa.password` | Password to be set for the created account | | * |
| `camsa.gdpr` | State if Chef is allowed to store your information. In the EU this is GDPR consent. | false | * |
| `camsa.chefserver.org.name` | Name of the organisation to be set on the Chef server | | * |
| `camsa.chefserver.org.description` | Description of the organisation to be set on the Chef server | | * |
| `camsa.tags` | See below | | |

During deployment the ARM templates add tags to the instance. From the instance it is possible to obtain these tags and Chef makes them available through attributes. However they are not in an object format. For example if two tags were to be set on the instance, such as:

```json
{
  "firstname": "foo",
  "lastname": "bar"
}
```

When referenced from the metadata this is presented as:

```
firstname:foo;lastname:bar
```

The `default` recipe splits this string up and sets it as an object in the `node['camsa']['tags']` for easy reference.

## directories.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.dirs.working` | Base working directory for CAMSA | `/usr/local/camsa` | |
| `camsa.dirs.bin` | Scripts and commands for CAMSA within the working dir | `#{node['camsa']['dirs']['working']}/bin` | |
| `camsa.dirs.etc` | Configuration files | `#{node['camsa']['dirs']['working']}/etc` | |
| `camsa.dirs.archive` | Location for files that are moved or replaced | `#{node['camsa']['dirs']['working']}/archive` | |
| `camsa.dirs.flags` |Files used as semaphores to ensure that processes that are not inherently idempotent can be made to be | `#{node['camsa']['dirs']['working']}/flags` | |
| `camsa.dirs.data` | Snippets of information required by the setup | `#{node['camsa']['dirs']['working']}/data` | |

## storage_account.rb

| Attribute | Description | Default Value | Required |
|---|---|---|---|---|
| `camsa.storage_account.name` | Name of the storage account to be used to store backups | | * |
| `camsa.storage_account.access_key` | Access key associated with the specified storage account | | * |
| `camsa.storage_account.container_name` | Container within the storage account to upload files to | | * |