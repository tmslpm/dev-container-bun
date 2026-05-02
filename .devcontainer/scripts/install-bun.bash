#!/usr/bin/env bash
set -euo pipefail

error() { echo -e "[error]" "$@" >&2; exit 1; }

# Required tools (all present in mcr.microsoft.com/devcontainers/base:noble)
command -v unzip     >/dev/null || error 'unzip is required'
command -v curl      >/dev/null || error 'curl is required'
command -v sha256sum >/dev/null || error 'sha256sum is required'

# Args: version, sha256_x64, sha256_aarch64
[[ $# -eq 3 ]] || error 'Usage: install-bun.bash <bun-tag> <sha256_x64> <sha256_aarch64>'
version=$1
sha_x64=$2
sha_aarch64=$3

# Detect architecture and select expected checksum
case $(uname -m) in
    aarch64 | arm64)
        target=linux-aarch64
        expected_sha=$sha_aarch64
        ;;
    x86_64)
        target=linux-x64
        expected_sha=$sha_x64
        ;;
    *)
        error "Unsupported architecture: $(uname -m)"
        ;;
esac

# Alpine uses musl instead of glibc
if [[ -f /etc/alpine-release ]]; then
    target="$target-musl"
fi

# AVX2 fallback for x64 (must come after musl suffix)
if [[ "$target" == linux-x64* ]] && ! grep -q avx2 /proc/cpuinfo; then
    target="$target-baseline"
fi

# Download
install_dir=/usr/local/bin
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

bun_uri="https://github.com/oven-sh/bun/releases/download/$version/bun-$target.zip"

curl --fail --location --progress-bar --output "$tmp/bun.zip" "$bun_uri" \
    || error "Failed to download bun from \"$bun_uri\""

# Verify checksum
echo "${expected_sha}  $tmp/bun.zip" | sha256sum -c - \
    || error "Checksum mismatch for $bun_uri"

# Extract and install
unzip -oqd "$tmp" "$tmp/bun.zip" \
    || error 'Failed to extract bun'

install -m 755 "$tmp/bun-$target/bun" "$install_dir/bun" \
    || error 'Failed to install bun'

echo "[success] bun $version installed to $install_dir/bun"
