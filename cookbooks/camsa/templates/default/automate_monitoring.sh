#!/usr/bin/env bash

journalctl -fu chef-automate --since "5 minutes ago" --until "now" -o json > /var/log/jsondump.json
curl -H "Content-Type: application/json" -H "x-functions-key: <%= @apikey %>" -X POST -d @/var/log/jsondump.json <%= @function_url %>