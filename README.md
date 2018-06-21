# Jupyterhub docker environment

## Prerequisites

`docker` and `docker-compose`: you can install docker-compose via `pip`, globally for ease of use. If you are installing on
a Redhat based system, add `docker-compose` program to the sudoers file with a `NOPASSWD` directive. For Debian based
systems, adding the group `docker` and adding your user to this groups will do.

## Preparing for the build

Generate docker network and volumes. Once done, this step will not have to be repeated. The `Makefile` has directives
for creating these. The commands run by the `Makefile` amounts to the commands below:

```
docker network inspect $DOCKER_NETWORK_NAME >/dev/null 2>&1 || docker network create $DOCKER_NETWORK_NAME
docker volume create --name=jupyterhub-db-data
docker volume create --name=jupyterhub-data

```
Further more, the `Makefile` will generate the postgresql password and certificate for jupyterhub. There are files in
the `scripts` folder for these steps. If the postgres password is changed it is necessary to either rebuild the docker
volume or perform a reset of the password in the postgres container

## Building the docker containers

```
docker-compose build
```

## Running the jupyterhub server

```
docker-compose up -d
```

And check that the docker containers are running with `docker ps` and `docker logs jupyterhub`

## Customizing the notebook python dependencies

The notebook image will be installed with dependencies listed in the `python/requirements.txt` file. If the file is
changed, the `docker-compose build` process will automatically invalidate its cache and rebuild the docker image. In
order to load the rebuilt notebook image, the jupyter session will have to be restarted from within jupyterhub..

## Jupyterhub setup

The `jupyterhub_config.py` file specifices the configuration of the jupyterhub container. The hub uses PAM to
authenticate users from the configuration on the host machine. Look at
https://github.com/jupyterhub/jupyterhub/wiki/Authenticators for alternative authentication methods.
