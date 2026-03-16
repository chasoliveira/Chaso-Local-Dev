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

- [`dotfiles/`](./dotfiles/): versionable shell and Git config
- [`vscode/`](./vscode/): user settings and extension recommendations
- [`vscode/profiles/`](./vscode/profiles/): importable profile presets
- [`docker/`](./docker/): local services stack for backend work
- [`scripts/`](./scripts/): bootstrap and symlink helpers
- [`docs/`](./docs/): current machine audit and setup notes

## Quick start

1. Review the files in [`dotfiles/`](./dotfiles/), [`vscode/`](./vscode/), and [`docker/`](./docker/).
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

## Docker In WSL2

If WSL shows `The command 'docker' could not be found in this WSL 2 distro`, enable Docker Desktop integration for your distro in Windows.

1. Install or open Docker Desktop on Windows.
2. In Docker Desktop, open `Settings`.
3. In `General`, make sure `Use WSL 2 based engine` is enabled.
4. In `Resources` > `WSL Integration`, enable integration for your Ubuntu distro.
5. Click `Apply & Restart`.
6. Back in WSL, verify Docker is available:

```bash
docker version
docker context ls
```

If your distro is not the default WSL distro, Docker says integration is enabled by default only for the default distro. You can check or change that from Windows PowerShell:

```powershell
wsl --list --verbose
wsl --set-default Ubuntu
```

If Docker Desktop is in Windows container mode, switch it back to Linux containers before retrying.

References:

- [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl-tech-preview/)
- [Docker Desktop settings on Windows](https://docs.docker.com/desktop/settings-and-maintenance/settings/)

## Current direction

The initial baseline reflects your current machine:

- Bash shell
- `oh-my-posh`
- `nvm` with Node 20 as default
- Python 3.10
- .NET SDK 10.0.103
- VS Code with Python, C#, Copilot, ChatGPT, and Vitest-related tooling

See [Current Environment Audit](./docs/current-environment-audit.md) for the captured inventory and follow-up recommendations.
