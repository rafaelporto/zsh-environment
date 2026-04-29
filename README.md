# ZSH Environment

Personal ZSH configuration files for macOS and Linux.

## Structure

```
zsh-environment/
├── zshrc          # Main ZSH config (Oh My Zsh, plugins, theme, tools)
├── zprofile       # Login profile (aliases, PATH exports, utility functions)
├── p10k.zsh       # Powerlevel10k theme configuration
├── setup.sh       # One-shot setup: dependencies + symlinks + validation
├── bootstrap.sh   # Installs required dependencies (Homebrew, OMZ, zplug, p10k)
├── install.sh     # Sets up symlinks from ~/ to this repo
├── check.sh       # Validates the installation
└── private/       # Work-specific configs — gitignored, never committed
    └── work.zsh   # Created manually on each machine (see below)
```

## How it works

`setup.sh` is the single entry point for a new machine: it installs dependencies, creates symlinks, and validates the setup. Internally it calls `bootstrap.sh`, `install.sh`, and `check.sh` in sequence — each of which can also be run independently.

`install.sh` replaces `~/.zshrc`, `~/.zprofile`, and `~/.p10k.zsh` with symlinks pointing to this repo. Any change committed here takes effect immediately in new terminal sessions.

`check.sh` validates the installation: confirms that the symlinks point to the correct files, that `private/` is set up correctly, that no private files are tracked by git, and that `zshrc` and `zprofile` have no syntax errors.

Work-specific configuration lives in `private/work.zsh`, which is sourced at the end of both `zshrc` and `zprofile` if the file exists. This file is gitignored and must be created manually on each machine — it is never tracked by this repository.

## Installing on a new machine

1. Clone the repo:
   ```bash
   git clone <repo-url> ~/.config/zsh-environment
   ```

2. Run the setup script:
   ```bash
   cd ~/.config/zsh-environment
   chmod +x setup.sh bootstrap.sh install.sh check.sh
   ./setup.sh
   ```

   `setup.sh` will ask before installing each dependency, then create the symlinks and validate everything.

3. Create `private/work.zsh` with your work-specific configs:
   ```bash
   touch ~/.config/zsh-environment/private/work.zsh
   # edit it with your work aliases, exports, and functions
   ```

4. Open a new terminal.

### Running steps individually

| Script | Purpose |
|--------|---------|
| `./bootstrap.sh` | Install dependencies only (Homebrew, Oh My Zsh, zplug, Powerlevel10k) |
| `./install.sh` | Create symlinks only |
| `./check.sh` | Validate the installation |

## Adding new configs

| Type | Where |
|------|-------|
| Generic aliases, functions, exports | `zprofile` or `zshrc` |
| Work-specific configs (internal URLs, company tools, credentials) | `private/work.zsh` only |
