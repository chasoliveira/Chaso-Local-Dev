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
- Caddy: shared local reverse proxy for stable `*.localhost` service names
- pgAdmin: quick DB inspection without extra host installs
- Mailpit: safe SMTP sink for local email testing
- Portainer: lightweight local Docker UI for inspecting containers, volumes, networks, and stacks
- RabbitMQ: common broker for async workflows
- Azurite: useful when .NET or Node services use Azure storage locally
- OpenBao: local secrets and token workflows without depending on Vault Cloud
- Loki + Grafana + Alloy: lightweight local observability stack for logs and dashboards

## Friendly local URLs

When the `proxy` profile is running, these hostnames are available through Caddy:

- Keycloak: `http://keycloak.localhost`
- pgAdmin: `http://pgadmin.localhost`
- Mailpit UI: `http://mailpit.localhost`
- Portainer: `http://portainer.localhost`
- RabbitMQ UI: `http://rabbitmq.localhost`
- Azurite Blob: `http://azurite-blob.localhost`
- Azurite Queue: `http://azurite-queue.localhost`
- Azurite Table: `http://azurite-table.localhost`
- OpenBao: `http://openbao.localhost`
- Loki API: `http://loki.localhost`
- Grafana: `http://grafana.localhost`
- Alloy UI: `http://alloy.localhost`

The default base domain comes from `LOCAL_BASE_DOMAIN` and is set to `localhost`.
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
api.localhost {
	reverse_proxy my-api:8080
}
```

## Stop

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml down
```
