#!/usr/bin/env bash

./docker-build.sh

sleep 10
# unseal vault
docker exec -it vault_server vault unseal aMf3xmMkRzGJYPSCF2A534yBx4QwEGUjNbWRLoTL+pav
docker exec -it vault_server vault unseal TvK0mwG6ZSKVJEjvLMlaxjXnbZGb+QLXPu837zZO9HjN
docker exec -it vault_server vault unseal ekV/EZTBp671c66upCsUEe421sm1V7mFjYQ6Gy+GENU0

# post logs to console
docker-compose logs -f
