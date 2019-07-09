#!/usr/bin/env bash

# This script is to be used in conjunction with the post-hook of the certbot
# command.
# If a certificate has been renewed this script will be executed.
# It will restart Automate and then patch it with the relevant files that have been generated

# FUNCTIONS ------------------------------------

# Function to output information
# This will be to the screen and to syslog
function log() {
  message=$1
  tabs=$2
  level=$3
  
  if [ "X$level" == "X" ]
  then
    level="notice" 
  fi

  if [ "X$tabs" != "X" ]
  then
    tabs=$(printf '\t%.0s' {0..$tabs})
  fi

  echo -e "${tabs}${message}"

  logger -t "AUTOMATE_SETUP" -p "user.${level}" $message
}

# Execute commands and keep a log of the commands that were executed
function executeCmd()
{
  localcmd=$1

    # Output the command to STDOUT as well so that it is logged inline with the error that are being seen
    # echo $localcmd

    # if a command log does not exist create one
    if [ ! -f commands.log ]
    then
        touch commands.log
    fi

    # Output the commands to the log file
    echo "$localcmd" >> commands.log

    eval "$localcmd"
}

# -----------------------------------------------

# Get the FQDN of the server from the command line arguments
fqdn=$1

# Start Chef Automate
executeCmd "chef-automate start"

# Set the paths to the certificate file and the private key
SSL_CERT_PATH=$(printf "/etc/letsencrypt/live/%s/fullchain.pem" $fqdn)
SSL_KEY_PATH=$(printf "/etc/letsencrypt/live/%s/privkey.pem" $fqdn)

# Only proceed if both of the files exist
if [ ! -f $SSL_CERT_PATH ] || [ ! -f $SSL_KEY_PATH ]
then
    log "Unable to find either certfificate file or private key" "" "error"
    exit 1
fi

pushd /var/lib/waagent/custom-script/download/0/

log "Reading Certificate and Key files"

# Get the contents of the files
ssl_certificate=`cat $SSL_CERT_PATH`
ssl_key=`cat $SSL_KEY_PATH`

# Write out the toml file for Automate
cat << EOF > ssl_cert.toml
[[global.v1.frontend_tls]]
# The TLS certificate for the load balancer frontend
cert = """
${ssl_certificate}
"""

# The TLS RSA key for the load balancer frontend
key = """
${ssl_key}
"""
EOF

# Patch automate
log "Patching Automate with the new certificates"
executeCmd "chef-automate config patch ssl_cert.toml"

# Now restart the Automate services
log "Restarting Services"
executeCmd "chef-automate restart-services"

popd