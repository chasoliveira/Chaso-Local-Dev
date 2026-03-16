# Current Environment Audit

Snapshot taken from the machine on 2026-03-14.

## Detected runtimes and tools

- Shell: Bash
- Prompt: `oh-my-posh`
- Node: `v20.19.3`
- npm: `11.4.2`
- `nvm` default alias: `20`
- Python: `3.10.12`
- .NET SDK: `10.0.103`
- VS Code remote CLI: `1.111.0`

## Docker status

- Docker Desktop binaries are installed on Windows.
- The WSL distro is not currently integrated with Docker Desktop.
- `docker` exists at `/mnt/c/Program Files/Docker/Docker/resources/bin/docker`, but the CLI reports that WSL integration is disabled for this distro.

## Current shell config

Observed in `~/.bashrc`:

- standard Ubuntu bash defaults
- `PATH` includes `~/.local/bin`
- `oh-my-posh init bash --config 'clean-detailed'`
- `nvm` load and bash completion

This is a good candidate to convert into a small, versioned shell layer instead of keeping everything directly in the generated Ubuntu default file.

## Current Git config

Observed in `~/.gitconfig`:

- `user.name = Charles Oliveira`
- `user.email = chasoliveira@outlook.com`

Safe to version in a template, but you may prefer placeholders if this repo becomes public.

## Current VS Code settings

Observed in Windows user settings:

- terminal font: `FiraCode Nerd Font`
- terminal font size: `12`
- Git autofetch enabled
- JSON and JavaScript formatters configured
- Docker Compose language server disabled
- telemetry disabled for Red Hat extension

## Likely installed VS Code extensions

Inferred from local cached VSIX data:

- `github.copilot-chat`
- `ms-dotnettools.csdevkit`
- `ms-dotnettools.csharp`
- `ms-dotnettools.vscode-dotnet-runtime`
- `ms-python.debugpy`
- `ms-python.python`
- `ms-python.vscode-pylance`
- `ms-python.vscode-python-envs`
- `openai.chatgpt`
- `vitest.explorer`

## Files that should not be versioned directly

- `~/.docker/config.json` because it points to desktop credential storage and may later include registry auth state
- VS Code `User/History`, `workspaceStorage`, logs, machine IDs, and caches
- telemetry IDs and salts from app-specific configs
- SSH keys, cloud credentials, NuGet credentials, npm auth, and local token stores

## Recommended next steps

1. Keep only intentional preferences in version control.
2. Use templates for shell, Git, VS Code, and Compose env vars.
3. Add a single bootstrap script to link dotfiles and print manual install reminders.
4. After Docker WSL integration is enabled, validate the local services stack.

