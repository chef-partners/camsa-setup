# Configure SSL key and cert for Chef Server
nginx["ssl_certificate"] = "<%= @cert_path %>"
nginx["ssl_certificate_key"] = "<%= @cert_key_path %>"