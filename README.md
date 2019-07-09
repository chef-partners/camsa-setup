# CAMSA Setup Cookbooks

This repository contains the files that are used to build the server policy files used to setup the servers when a Managed App for Chef Automate is deployed into Azure.

## Documentation

The documentation for the repository can be accessed from [here](https://chef-partners.github.io/camsa-setup).

However if there is a need to browse this offline or updates are required then it is possible to run the documentation website locally. To do this please ensure Docker is installed and then run the following command:

```
docker run --rm -v "${PWD}/docs:/srv/jekyll" -p 4000:4000 -e JEKYLL_ENV=docker jekyll/jekyll:3.8 jekyll serve --config _config.yml,_config.docker.yml
```

The documentation site will now be accessible on your local machine at http://localhost:4000.

