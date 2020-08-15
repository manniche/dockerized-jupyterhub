#!/bin/bash


echo "$USER admin" > userlist
mkdir secrets
openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -out secrets/cert.crt -keyout secrets/cert.key -days 365
echo "POSTGRES_PASSWORD=Fj43wqjfdaF" > secrets/postgres.env
docker volume create --name=jupyterhub-db-data
docker volume create --name=jupyterhub-data
docker network create adalab
