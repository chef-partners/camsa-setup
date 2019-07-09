---
title: backup.sh
parent: Files
nav_order: 10
layout: default
---

# backup.sh

Each of the components that are deployed within the CAMSA solution are backed up using this script.

There are a number of parameters that can be passed to the script which determine what and how is backed up. These include settings that allow the backups to be copied to Azure blob storage. The backups are then removed from the local disk.

## Parameters

The following table shows the parameters that are accepted by the script and any default values

| Name | Description | Default Value |
|---|---|---|
| -c, --config | Configuration file to use | |
| -s, --chunk-size | Size of the chunks to upload to Blob storage | 256Mb |
| -t, --type | Type of backup to perform. One of automate | |
| -w, --working-dir | Working directory to use to temporaily store the backup files | `/tmp/backup` |
| -v, --api-version | API version to use when uploading to blob storage | 2018-03-28 |

## Configuration

The backup script accepts a configuration file which contains the storage account settings to be used for Blog storage upload. This is a simple key value pair configuration file. An example of this can be seen below:

```
STORAGE_ACCOUNT=kjbn5646v
CONTAINER_NAME=backup
ACCESS_KEY=fa3032f1-5c96-4c67-97b0-4de15502d83c
```