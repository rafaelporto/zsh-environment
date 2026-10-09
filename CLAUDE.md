# ZSH Environment — Claude Instructions

## Context

This repository stores personal ZSH configuration files for macOS. The files here (`zshrc`, `zprofile`, `p10k.zsh`) are symlinked from `~/` via `install.sh`.

The `private/` directory holds the per-machine files, both gitignored and created manually on each machine — never committed to this repository:

- `work.zsh` — work-specific configuration; may contain secrets. Sourced at the end of `zshrc`.
- `machine.zsh` — machine switches (hardware/terminal), no secrets. Sourced before the Powerlevel10k block. Today it holds `ZSH_ENV_TTY_PROMPT=1`, which enables `p10k-tty.zsh` on the Linux console, and `ZSH_ENV_TTY_THEME=light`, the console palette — a line written and removed by the `ttytheme` command, not by hand.

`p10k-tty.zsh` and `tty-theme.zsh` are not symlinked: `zshrc` sources them straight from the repo, and only on Linux. `p10k-tty.zsh` also needs the opt-in and a console client; `tty-theme.zsh` only defines functions, and the palette is applied only where a theme was saved (see README).

## Directives

1. **No work-related information** — Never commit content tied to any employer: internal URLs, ARNs, AWS account IDs, proprietary tool commands, tokens, credentials, or references to private tooling of any kind.

2. **`private/` is always gitignored** — The rule `private/*` in `.gitignore` must never be removed or modified. Any work-specific config belongs exclusively in `private/work.zsh`, which is not tracked by git.

3. **Symlinks, not copies** — Files in `~/` must always be symlinks pointing to this repo. Never suggest copying files directly to `~/` or duplicating config content outside the repo structure.

4. **Documentation always up to date** — Any change to configuration files must be accompanied by an update to `README.md` if it affects the repository structure, installation steps, or usage.

5. **Machine-specific behavior is opt-in** — Every machine shares this repo, so anything meant for only some machines must stay inert by default: guard it by OS (`$OSTYPE`) where applicable and enable it through a switch in `private/machine.zsh`, never by changing behavior for everyone.
