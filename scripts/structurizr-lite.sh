#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="${1:-$PWD}"
WORKSPACE_FILE="workspace.dsl"
STRUCTURIZR_PORT="${STRUCTURIZR_PORT:-8081}"
STRUCTURIZR_IMAGE="${STRUCTURIZR_IMAGE:-structurizr/lite}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but was not found in PATH." >&2
  exit 1
fi

if [ ! -d "$WORKSPACE_DIR" ]; then
  echo "Workspace directory does not exist: $WORKSPACE_DIR" >&2
  exit 1
fi

WORKSPACE_DIR="$(cd "$WORKSPACE_DIR" && pwd)"

if [ ! -f "$WORKSPACE_DIR/$WORKSPACE_FILE" ]; then
  echo "Structurizr workspace not found: $WORKSPACE_DIR/$WORKSPACE_FILE" >&2
  echo "Run this command from a directory containing workspace.dsl, or pass the workspace directory as the first argument." >&2
  exit 1
fi

echo "Starting Structurizr Lite for $WORKSPACE_DIR/$WORKSPACE_FILE"
echo "Open http://localhost:$STRUCTURIZR_PORT"

docker run \
  --interactive \
  --tty \
  --rm \
  --publish "$STRUCTURIZR_PORT:8080" \
  --volume "$WORKSPACE_DIR:/usr/local/structurizr" \
  "$STRUCTURIZR_IMAGE"
