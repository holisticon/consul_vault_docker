# Showcase for Jenkins, Consul and Vault

[![Build Status](https://travis-ci.org/holisticon/consul_vault_docker.svg?branch=master)](https://travis-ci.org/holisticon/consul_vault_docker)

![Compose Visualization](https://raw.githubusercontent.com/holisticon/consul_vault_docker/master/docker-compose.png "Visualization of Compose")


Consul and Vault are started together in two separate, but linked, docker containers.

Vault is configured to use a `consul` [secret backend](https://www.vaultproject.io/docs/secrets/consul/).


## Requirements

* Docker 17+
* cygwin/bash on Windows

## Usage

Setup images:
```
./docker-setup.sh 
```

Afterwards you can use `./docker-run.sh` without resetting the data

>NOTES: The unseal is done automatically per intention to ease setup.
>**Do not use in production!**

Login for Jenkins at http://localhost:8080 is admin / admin

To use the "fake" production vault server via CLI add a bash alias:
```
alias vault='docker exec -it vault_server vault "$@"'
```
Look at `docker-setup.sh` for an example

## Advanced Usage

Command below starts a Vault server in dev mode with a known initial root token that we can use for dev and tests and listening on http://localhost:8200

```
vault server -dev -log-level=INFO -dev-root-token-id=00000000-0000-0000-0000-000000000000
```

Before using the CLI to configure the vault, you must set this environment variable:

```
export VAULT_ADDR=http://localhost:8200
```

Add some secret application properties.

```
# default application, default profile
vault write secret/application spring.datasource.username=default-user spring.datasource.password=default-pass

# demo application, default profile
vault write secret/vault-demo spring.datasource.username=demo-user spring.datasource.password=demo-pass

# demo application, dev profile
vault write secret/vault-demo/dev spring.datasource.username=demo-user-dev spring.datasource.password=demo-pass-dev

```

## Background

### Persistence

All the runtime data of docker is saved under `runtime/docker`

### Initial Config

The initial config was made by logging in the image:

```bash
docker exec -it vault_server sh
```

Check Vault's status:

```bash
$ vault status
Error checking seal status: Error making API request.

URL: GET http://127.0.0.1:8200/v1/sys/seal-status
Code: 400. Errors:

* server is not yet initialized
```

Because Vault is not yet initialized, it is sealed, that's why Consul will show you a sealed critial status.

### Init Vault

```bash
$ vault init
Unseal Key 1: aMf3xmMkRzGJYPSCF2A534yBx4QwEGUjNbWRLoTL+pav
Unseal Key 2: FJ/LVcncftgjDi0T1wiKXZb9bEPW2P0dk/TUBBtMj8rJ
Unseal Key 3: TvK0mwG6ZSKVJEjvLMlaxjXnbZGb+QLXPu837zZO9HjN
Unseal Key 4: Oi8J8lUtiz1SivSfqSaqLP+OU4cFQOikN8mAgJ+ADVoE
Unseal Key 5: ekV/EZTBp671c66upCsUEe421sm1V7mFjYQ6Gy+GENU0
Initial Root Token: a35c086a-6faf-8d35-2bed-8cedec6debd1

Vault initialized with 5 keys and a key threshold of 3. Please
securely distribute the above keys. When the Vault is re-sealed,
restarted, or stopped, you must provide at least 3 of these keys
to unseal it again.

Vault does not store the master key. Without at least 3 keys,
your Vault will remain permanently sealed.
```

notice Vault says:

> you must provide at least 3 of these keys to unseal it again

hence it needs to be unsealed 3 times with 3 different keys (out of the 5 above)

### Unsealing Vault

```bash
$ vault unseal
Key (will be hidden):
Sealed: true
Key Shares: 5
Key Threshold: 3
Unseal Progress: 1

$ vault unseal
Key (will be hidden):
Sealed: true
Key Shares: 5
Key Threshold: 3
Unseal Progress: 2

$ vault unseal
Key (will be hidden):
Sealed: false
Key Shares: 5
Key Threshold: 3
Unseal Progress: 0
```

the Vault is now unsealed.

### Auth with Vault

We can use the `Initial Root Token` from above to auth with the Vault:

```bash
$ vault auth
Token (will be hidden):
Successfully authenticated! You are now logged in.
token: 5a4a7e11-1e2f-6f76-170e-b8ec58cd2da5
token_duration: 0
token_policies: [root]
```

---

All done: now you have both Consul and Vault running side by side.

## Making sure it actually works

From the host environment (i.e. outside of the docker image):

```bash
alias vault='docker exec -it vault_server vault "$@"'
```

This will allow to run `vault` commands without a need to logging in to the image.

> the reason commands will work is because you just `auth`'ed (logged into Vault) with a root token inside the image in the previous step.

### Watch Consul logs

In one terminal tail Consul logs:

```bash
$ docker logs consul_server -f
```

### Writing / Reading Secrets

In the other terminal run vault commands:

```bash
$ vault write -address=http://127.0.0.1:8200 secret/billion-dollars value=behind-super-secret-password
```
```
Success! Data written to: secret/billion-dollars
```

Check the Consul log, you should see something like:

```bash
2016/12/28 06:52:09 [DEBUG] http: Request PUT /v1/kv/vault/logical/a77e1d7f-a404-3439-29dc-34a34dfbfcd2/billion-dollars (199.657µs) from=172.28.0.3:50260
```

Let's read it back:

```bash
$ vault read secret/billion-dollars
```
```
Key             	Value
---             	-----
refresh_interval	2592000
value           	behind-super-secret-password

```

## FAQ

### Update docker-compose.png
```
docker run --rm -it --name dcv -v $(pwd):/input pmsipilot/docker-compose-viz render -m image docker-compose.yml
```
