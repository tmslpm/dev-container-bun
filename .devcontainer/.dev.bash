#!/usr/bin/env bash
set -euo pipefail

container_image="mcr.microsoft.com/devcontainers/base:noble"
bun_version="bun-v1.1.34"

podman pull mcr.microsoft.com/devcontainers/base:noble
podman inspect --format='{{index .RepoDigests 0}}' mcr.microsoft.com/devcontainers/base:noble

echo
echo "ARG BUN_SHA256_X64"
curl -fsSL https://github.com/oven-sh/bun/releases/download/$bun_version/bun-linux-x64.zip | sha256sum

echo
echo "ARG BUN_SHA256_AARCH64"
curl -fsSL https://github.com/oven-sh/bun/releases/download/$bun_version/bun-linux-aarch64.zip | sha256sum
