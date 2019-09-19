#!/usr/bin/env bash

# Determine the command to use to stop the service based on what commands
# are installed on the server
if [ -f '/usr/local/bin/chef-automate' ]
  PRE_HOOK="chef-automate stop"
  POST_HOOK="<%= @renew_cert_path %>"
else
  PRE_HOOK="chef-server-ctl stop nginx"
  POST_HOOK="chef-server-ctl start nginx"
fi

certbot renew --pre-hook "${PRE_HOOK}" --post-hook "${POST_HOOK}"