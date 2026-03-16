# Local Services

The Compose stack is designed for backend work across Python, .NET, and Node projects.
The default startup path is intentionally small.

## Default services

- Postgres
- Redis
- Keycloak

## Optional services

- pgAdmin
- Mailpit
- RabbitMQ
- Azurite

## Why these

- Postgres: default relational database for app development
- Redis: cache, queue, and distributed lock scenarios
- Keycloak: local identity provider for OAuth2/OpenID Connect flows, using the main Postgres instance
- pgAdmin: quick DB inspection without extra host installs
- Mailpit: safe SMTP sink for local email testing
- RabbitMQ: common broker for async workflows
- Azurite: useful when .NET or Node services use Azure storage locally

## Suggested URLs

- Keycloak: `http://localhost:8080`
- pgAdmin: `http://localhost:5050`
- Mailpit UI: `http://localhost:8025`
- RabbitMQ UI: `http://localhost:15672`

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
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile tools up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile messaging up -d
docker compose --env-file docker/.env -f docker/docker-compose.yml --profile azure up -d
```

Available profiles:

- `tools`: pgAdmin and Mailpit
- `messaging`: RabbitMQ
- `azure`: Azurite

On first boot, Postgres automatically creates the `keycloak` database from `docker/postgres-init/01-create-keycloak-db.sql`.
If the Postgres volume already exists, that init script will not run again, so create the database manually or recreate the volume.

## Stop

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml down
```
