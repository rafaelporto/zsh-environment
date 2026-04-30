# ZSH Environment

Personal ZSH configuration files for macOS and Linux.

## Structure

```
zsh-environment/
├── zshrc          # Main ZSH config (Oh My Zsh, plugins, theme, tools)
├── zprofile       # Login profile (aliases, PATH exports, utility functions)
├── p10k.zsh       # Powerlevel10k theme configuration
├── setup.sh       # One-shot setup: dependencies + symlinks + validation
├── bootstrap.sh   # Installs required dependencies
├── install.sh     # Sets up symlinks from ~/ to this repo
├── check.sh       # Validates the installation
└── private/       # Work-specific configs — gitignored, never committed
    └── work.zsh   # Created manually on each machine (see below)
```

## How it works

`setup.sh` is the single entry point for a new machine: it installs dependencies, creates symlinks, and validates the setup. Internally it calls `bootstrap.sh`, `install.sh`, and `check.sh` in sequence — each of which can also be run independently.

`install.sh` replaces `~/.zshrc`, `~/.zprofile`, and `~/.p10k.zsh` with symlinks pointing to this repo. Any change committed here takes effect immediately in new terminal sessions.

`check.sh` validates the installation: confirms that the symlinks point to the correct files, that `private/` is set up correctly, that no private files are tracked by git, and that `zshrc` and `zprofile` have no syntax errors.

Work-specific configuration lives in `private/work.zsh`, which is sourced at the end of `zshrc` if the file exists. This file is gitignored and must be created manually on each machine — it is never tracked by this repository.

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
| `./bootstrap.sh` | Install dependencies only |
| `./install.sh` | Create symlinks only |
| `./check.sh` | Validate the installation |

## Dependencies

### Required (installed by bootstrap)

| Tool | Purpose | Aliases | Config |
|------|---------|---------|--------|
| `git` | Version control | `add`, `st`, `ci`, `push`, `co`, `pull`, `lg`, and others | — |
| `curl` | HTTP requests | `myip` | — |
| `zsh` | Shell | — | — |
| `tmux` | Terminal multiplexer | `tx`, `txa`, `txn`, `txl`, `txk`, `tConfig`, `tConfigReload` | [tmux-environment](https://github.com/rafaelporto/tmux-environment) ¹ |
| `nvim` | Text editor (default `$EDITOR`) | `nv`, `nv.`, `nvconfig`, and others | [neo-vim-environment](https://github.com/rafaelporto/neo-vim-environment) ¹ |
| `jq` | JSON processor | `flattenJson`, `jwt-decode`, `catFileWithColors` | — |
| `lazygit` | Terminal UI for git | `lg` | — |

> ¹ Personal configuration repository — optional, bring your own config.

### Framework (installed by bootstrap)

| Tool | Purpose |
|------|---------|
| Homebrew | Package manager for macOS and Linux |
| Oh My Zsh | ZSH framework |
| zplug | ZSH plugin manager (installs `zsh-syntax-highlighting`) |
| Powerlevel10k | ZSH prompt theme |

### Optional — aliases activated when installed

These tools are not required. If installed, their aliases are automatically activated in `zprofile`. If not installed, they are silently skipped.

| Tool | Purpose | Aliases | Config |
|------|---------|---------|--------|
| `kitty` | Terminal emulator | `kittytheme`, `nvkitty`, `updateKitty` | [kitty-config](https://github.com/rafaelporto/kitty-config) ¹ |
| `dotnet` | .NET SDK | `dn`, `dnb`, `dnr`, `dnc`, `dnrt`, `dnt` | — |
| `clj` | Clojure CLI | `cljReplRun` | — |
| `databricks` | Databricks CLI | `dbc` | — |
| `npm` | Node package manager | `n`, `nr`, `ni` | — |
| `op` | 1Password CLI | shell completion | — |

> ¹ Personal configuration repository — optional, bring your own config.

### Recommended — suggested by bootstrap when applicable

| Tool | When suggested | Purpose |
|------|---------------|---------|
| NVM | When `npm` is found without NVM, or on first install | Manages multiple Node.js versions |
| SDKMAN | When `java` is found without SDKMAN, or on first install | Manages Java and other JVM tool versions |

### Pre-installed (no action needed)

| Tool | Notes |
|------|-------|
| `vim` | Available on all Unix systems |
| `openssl` | Pre-installed on macOS; available via Homebrew on Linux |
| `lsof` | Pre-installed on macOS and most Linux distributions |
| `dig` | Pre-installed on macOS; part of `dnsutils` on Linux |
| `gcloud` | Sourced automatically if installed at standard paths |

## Adding new configs

| Type | Where |
|------|-------|
| Generic aliases, functions, exports | `zprofile` or `zshrc` |
| Work-specific configs (internal URLs, company tools, credentials) | `private/work.zsh` only |
