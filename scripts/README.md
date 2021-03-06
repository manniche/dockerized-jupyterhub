# Generating secret files for the docker containers

# Postgres password

The jupyterhub uses a postgres DB to store user session information etc. in. In order to automate the setup, a variable
- `POSTGRES_PASSWORD` - is generated into a file which is then imported into both the jupyterhub container as well as
  the postgresql container. The password file is generated by standing in this (the `scripts` folder) and issuing the
  command

  ````
  ./generate_postgres_password.sh
  ```

# Certificates

Jupyterhub requires a certificate in order to run ([https://github.com/jupyterhub/jupyterhub/issues/561](Workarounds
exists), but are discouraged). For a local test deployment, the easiest way to get up and running is to create a
self-signed certificate. For public-facing installations, the best route is to use Let's Encrypt to generate a
certificate that will be recognized by browsers. The jupyterhub team has provided instructions and mechanisms suitable
for the docker setup which are explained under the [Let's Encrypt](Let's Encrypt section)

## Self-signed certificate

This is easily done using `openssl`. The script `generate_certificate.sh` will generate a 4096
bit key and certificate for the FQDN `localhost` and place them in the `secrets` folder. These files will be
automatically picked up by the `docker-compose` build process.

## Let's Encrypt

This example includes a Docker Compose configuration file that you can
use to deploy [JupyterHub](https://github.com/jupyter/jupyterhub) with
TLS certificate and key files generated by [Let's Encrypt](https://letsencrypt.org).

The `docker-compose.yml` configuration file in this example extends the
JupyterHub service defined in the `docker-compose.yml` file in the root
directory of this repository.  

When you run the JupyterHub Docker container using the configuration
file in this directory, Docker mounts an additional volume containing
the Let's Encrypt TLS certificate and key files, and overrides the
`SSL_CERT` and `SSL_KEY` environment variables to point to these files.

### Create a secrets volume

This example stores the Let's Encrypt TLS certificate and key files in
a Docker volume, and mounts the volume to the JupyterHub container at
runtime.  

Create a volume to store the certificate and key files.

```
# Activate Docker machine where JupyterHub will run
eval "$(docker-machine env jupyterhub)"

docker volume create --name jupyterhub-secrets
```

### Generate Let's Encrypt certificate and key

Run the `letsencrypt.sh` script to create a TLS full-chain certificate
and key.  

The script downloads and runs the `letsencrypt` Docker image to create a
full-chain certificate and private key, and stores the files in a Docker
volume.  You must provide a valid, routable, fully-qualified domain name (you
must own it), and you must activate the Docker machine host that the domain
points to before you run this script.  You must also provide a valid email
address and the name of the volume you created above.

_Notes:_ The script hard codes several `letsencrypt` options, one of which
automatically agrees to the Let's Encrypt Terms of Service.

```
# Activate Docker machine where JupyterHub will run
eval "$(docker-machine env jupyterhub)"

./letsencrypt.sh \
  --domain myhost.mydomain \
  --email me@mydomain \
  --volume jupyterhub-secrets
```

### Run JupyterHub container

To run the JupyterHub container using the Let's Encrypt certificate and key,
set the `SECRETS_VOLUME` environment variable to the name of the Docker volume
containing the certificate and key files, and run `docker-compose` **from the
root directory** of this repository while specifying the `docker-compose.yml`
configuration in this directory:

```
export SECRETS_VOLUME=jupyterhub-secrets

docker-compose -f examples/letsencrypt/docker-compose.yml up -d
```
