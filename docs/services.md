# Local Services

The Compose stack is designed for backend work across Python, .NET, and Node projects.
The default startup path is intentionally small.

## Default services

- Postgres
- Redis
- Keycloak

## Optional services

- Caddy
- pgAdmin
- Mailpit
- Portainer
- RabbitMQ
- Azurite
- OpenBao
- Loki
- Grafana
- Alloy

## Why these

- Postgres: default relational database for app development
- Redis: cache, queue, and distributed lock scenarios
- Keycloak: local identity provider for OAuth2/OpenID Connect flows, using the main Postgres instance
- Caddy: shared local reverse proxy for stable subdomain-based local service names
- pgAdmin: quick DB inspection without extra host installs
- Mailpit: safe SMTP sink for local email testing
- Portainer: lightweight local Docker UI for inspecting containers, volumes, networks, and stacks
- RabbitMQ: common broker for async workflows
- Azurite: useful when .NET or Node services use Azure storage locally
- OpenBao: local secrets and token workflows without depending on Vault Cloud
- Loki + Grafana + Alloy: lightweight local observability stack for logs and dashboards

## Friendly local URLs

When the `proxy` profile is running and your local DNS resolves `*.local.test` to `127.0.0.1`, these hostnames are available through Caddy:

- Keycloak: `http://keycloak.local.test`
- pgAdmin: `http://pgadmin.local.test`
- Mailpit UI: `http://mailpit.local.test`
- Portainer: `http://portainer.local.test`
- RabbitMQ UI: `http://rabbitmq.local.test`
- Azurite Blob: `http://azurite-blob.local.test`
- Azurite Queue: `http://azurite-queue.local.test`
- Azurite Table: `http://azurite-table.local.test`
- OpenBao: `http://openbao.local.test`
- Loki API: `http://loki.local.test`
- Grafana: `http://grafana.local.test`
- Alloy UI: `http://alloy.local.test`

The default base domain comes from `LOCAL_BASE_DOMAIN` and is set to `local.test`.
Postgres, Redis, and other raw TCP protocols still use their direct ports because this Caddy setup proxies HTTP services only.

## Direct URLs

Direct host ports still work and are useful for non-HTTP clients or when Caddy is not running:

- Keycloak: `http://localhost:8080`
- pgAdmin: `http://localhost:5050`
- Mailpit UI: `http://localhost:8025`
- Portainer: `http://localhost:9000`
- RabbitMQ UI: `http://localhost:15672`
- OpenBao: `http://localhost:8200`
- Loki API: `http://localhost:3100`
- Grafana: `http://localhost:3000`
- Alloy UI: `http://localhost:12345`

## Start

```bash
cp docker/.env.example docker/.env
docker compose --env-file docker/.env -f docker/docker-compose.yml up -d
```

That starts only the core stack:

- Postgres
- Redis
- Keycloak

## Start optional services

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile proxy up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile tools up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile pgadmin up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile portainer up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile messaging up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile azure up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile secrets up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile observability up -d
```

Available profiles:

- `proxy`: Caddy
- `caddy`: Caddy only
- `tools`: pgAdmin, Mailpit, and Portainer
- `pgadmin`: pgAdmin only
- `portainer`: Portainer only
- `messaging`: RabbitMQ
- `azure`: Azurite
- `secrets`: OpenBao
- `openbao`: OpenBao only
- `observability`: Loki, Grafana, and Alloy
- `loki`: Loki only
- `grafana`: Grafana only
- `alloy`: Alloy only

Grafana is provisioned with Loki as a datasource automatically.
OpenBao runs in dev mode with the root token from `OPENBAO_DEV_ROOT_TOKEN`.
Caddy serves friendly local hostnames on `CADDY_HTTP_PORT`, which defaults to `80`.

## Windows And WSL DNS Setup

To make `*.local.test` resolve in both Windows and WSL:

1. Start the proxy:

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile proxy up -d
```

2. Add Windows hosts entries that point your local names to `127.0.0.1`.
3. Add matching WSL hosts entries that point the same names to `127.0.0.1`.

Windows hosts file:

```text
C:\Windows\System32\drivers\etc\hosts
```

Example entries:

```text
127.0.0.1 keycloak.local.test
127.0.0.1 pgadmin.local.test
127.0.0.1 mailpit.local.test
127.0.0.1 portainer.local.test
127.0.0.1 rabbitmq.local.test
127.0.0.1 azurite-blob.local.test
127.0.0.1 azurite-queue.local.test
127.0.0.1 azurite-table.local.test
127.0.0.1 openbao.local.test
127.0.0.1 loki.local.test
127.0.0.1 grafana.local.test
127.0.0.1 alloy.local.test
```

WSL hosts file:

```text
/etc/hosts
```

Example command:

```bash
cat <<'EOF' | sudo tee -a /etc/hosts
127.0.0.1 keycloak.local.test
127.0.0.1 pgadmin.local.test
127.0.0.1 mailpit.local.test
127.0.0.1 portainer.local.test
127.0.0.1 rabbitmq.local.test
127.0.0.1 azurite-blob.local.test
127.0.0.1 azurite-queue.local.test
127.0.0.1 azurite-table.local.test
127.0.0.1 openbao.local.test
127.0.0.1 loki.local.test
127.0.0.1 grafana.local.test
127.0.0.1 alloy.local.test
EOF
```

Then test:

```bash
getent hosts pgadmin.local.test
curl -I http://pgadmin.local.test
```

If you later want a true wildcard resolver instead of hosts entries, run that resolver on the Windows host rather than in Docker. On Docker Desktop with WSL, host port `53` is commonly already occupied, which prevents a containerized DNS server from binding cleanly.

On first boot, Postgres automatically creates the `keycloak` database from `docker/postgres-init/01-create-keycloak-db.sql`.
If the Postgres volume already exists, that init script will not run again, so create the database manually or recreate the volume.

## Add another stack

To expose another compose stack through the same local Caddy instance:

1. Attach that stack's HTTP service to the Docker network named by `LOCAL_DOCKER_NETWORK`.
2. Add a new `*.caddy` file under `docker/caddy/sites/`.
3. Restart the `caddy` service so it reloads the new route.

Example compose snippet for another stack:

```yaml
services:
  my-api:
    image: my-api:latest
    networks:
      - local-proxy

networks:
  local-proxy:
    external: true
    name: chaso-local-dev
```

Example site file:

```caddyfile
api.local.test {
	reverse_proxy my-api:8080
}
```

## Stop

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml down
```
