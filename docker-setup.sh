#!/usr/bin/env bash


rm -rf docker/container

# add predfined consul config
mkdir -p runtime/docker/container/consul/data/
cp -rp src/main/docker/consul/data/ runtime/docker/container/consul/data/

./docker-build.sh
./docker-run.sh


sleep 60
## SETUP VAULT
## DON'T USE IN PRODUCTION!!!

TOKEN="a35c086a-6faf-8d35-2bed-8cedec6debd1"
# alias
function vault(){
    docker exec -it vault_server vault "$@"
}

vault auth $TOKEN
## tag::vault-sample-values[]
vault write secret/vault-demo admin.user=default-user admin.password=default-pass
## end::vault-sample-values[]