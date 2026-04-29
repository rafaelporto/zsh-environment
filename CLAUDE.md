# ZSH Environment — Claude Instructions

## Context

This repository stores personal ZSH configuration files for macOS. The files here (`zshrc`, `zprofile`, `p10k.zsh`) are symlinked from `~/` via `install.sh`.

The `private/` directory holds work-specific configuration in `work.zsh`. This file is gitignored and must be created manually on each machine — it is never committed to this repository.

## Directives

1. **No work-related information** — Never commit content tied to any employer: internal URLs, ARNs, AWS account IDs, proprietary tool commands, tokens, credentials, or references to private tooling of any kind.

2. **`private/` is always gitignored** — The rule `private/*` in `.gitignore` must never be removed or modified. Any work-specific config belongs exclusively in `private/work.zsh`, which is not tracked by git.

3. **Symlinks, not copies** — Files in `~/` must always be symlinks pointing to this repo. Never suggest copying files directly to `~/` or duplicating config content outside the repo structure.

4. **Documentation always up to date** — Any change to configuration files must be accompanied by an update to `README.md` if it affects the repository structure, installation steps, or usage.
