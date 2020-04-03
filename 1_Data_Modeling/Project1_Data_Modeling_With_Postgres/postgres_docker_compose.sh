#!/bin/bash

mkdir postgres
cd postgres

docker volume create --driver local --name=pgvolume
docker volume create --driver local --name=pga4volume

docker network create --driver bridge pgnetwork

cat << EOF > pg-env.list
PG_MODE=primary
PG_PRIMARY_USER=postgres
PG_PRIMARY_PASSWORD=admin

PG_DATABASE=sparkifydb
PG_USER=sparkifydb
PG_PASSWORD=sparkifydb

PG_ROOT_PASSWORD=postgres

PG_PRIMARY_PORT=5432
EOF

cat << EOF > pgadmin-env.list
PGADMIN_SETUP_EMAIL=pgadmin@example.com
PGADMIN_SETUP_PASSWORD=admin
SERVER_PORT=5050
EOF

docker run --publish 5432:5432 \
  --volume=pgvolume:/pgdata \
  --env-file=pg-env.list \
  --name="postgres" \
  --hostname="postgres" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-postgres:centos7-10.9-2.4.1

docker run --publish 5050:5050 \
  --volume=pga4volume:/var/lib/pgadmin \
  --env-file=pgadmin-env.list \
  --name="pgadmin4" \
  --hostname="pgadmin4" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-pgadmin4:centos7-10.9-2.4.1

## Reference: https://info.crunchydata.com/blog/easy-postgresql-10-and-pgadmin-4-setup-with-docker
