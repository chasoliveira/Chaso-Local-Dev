# chaso-local-dev

Versioned local development environment for fast setup on a new machine.

This repo is meant to be your personal "local infra as code" baseline:

- terminal preferences
- Git defaults
- VS Code settings and extension recommendations
- backend runtime notes for Python, .NET, and Node via `nvm`
- Docker Compose services for common local dependencies
- a single Postgres instance shared by app workloads and Keycloak
- optional profiles for extra local tooling so the default stack stays lean

## What is included

- `dotfiles/`: versionable shell and Git config
- `vscode/`: user settings and extension recommendations
- `vscode/profiles/`: importable profile presets
- `docker/`: local services stack for backend work
- `scripts/`: bootstrap and symlink helpers
- `docs/`: current machine audit and setup notes

## Quick start

1. Review the files in `dotfiles/`, `vscode/`, and `docker/`.
2. Copy the environment file:

```bash
cp docker/.env.example docker/.env
```

3. Link the versioned dotfiles into your home directory:

```bash
bash scripts/link-dotfiles.sh
```

4. Start the local services stack after Docker Desktop WSL integration is enabled:

```bash
docker compose --env-file docker/.env -f docker/docker-compose.yml up -d
```

## Current direction

The initial baseline reflects your current machine:

- Bash shell
- `oh-my-posh`
- `nvm` with Node 20 as default
- Python 3.10
- .NET SDK 10.0.103
- VS Code with Python, C#, Copilot, ChatGPT, and Vitest-related tooling

See `docs/current-environment-audit.md` for the captured inventory and follow-up recommendations.
