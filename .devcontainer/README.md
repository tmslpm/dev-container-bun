# Dev Container

All base images and toolchains are pinned and checksum-verified.

- Ubuntu 24.04 (pinned by digest)
- Bun (pinned version, SHA256 verified)
- VS Code extensions auto-installed, see [`devcontainer.json`][devcontainer]

## Configuration

All pinned versions and SHA256 checksums live in [`devcontainer.json`][devcontainer]
under `build.args`:

```jsonc
{
  "name": "Bun Dev Container",
  "build": {
    "dockerfile": "Dockerfile",
    "args": { <-- HERE
      "BUN_VERSION": "1.x.x",
      ...  
    }
  },
  ...
}
```
