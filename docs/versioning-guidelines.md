# What To Version

Version these:

- shell startup additions you intentionally maintain
- Git defaults that reflect your working style
- VS Code settings and extension recommendations
- Docker Compose definitions and safe example env files
- bootstrap scripts for new machines

Do not version these:

- secrets
- tokens
- SSH keys
- machine IDs
- VS Code caches and workspace storage
- Docker auth config
- telemetry IDs

Rule of thumb: version preferences and automation, not credentials or local state.

