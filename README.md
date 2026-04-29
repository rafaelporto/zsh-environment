# ZSH Environment

Personal ZSH configuration files for macOS.

## Structure

```
zsh-environment/
├── zshrc          # Main ZSH config (Oh My Zsh, plugins, theme, tools)
├── zprofile       # Login profile (aliases, PATH exports, utility functions)
├── p10k.zsh       # Powerlevel10k theme configuration
├── install.sh     # Sets up symlinks from ~/ to this repo
├── check.sh       # Validates the installation
└── private/       # Work-specific configs — gitignored, never committed
    └── work.zsh   # Created manually on each machine (see below)
```

## How it works

`install.sh` replaces `~/.zshrc`, `~/.zprofile`, and `~/.p10k.zsh` with symlinks pointing to this repo. Any change committed here takes effect immediately in new terminal sessions.

Work-specific configuration lives in `private/work.zsh`, which is sourced at the end of both `zshrc` and `zprofile` if the file exists. This file is gitignored and must be created manually on each machine — it is never tracked by this repository.

## Installing on a new machine

1. Clone the repo:
   ```bash
   git clone <repo-url> ~/.config/zsh-environment
   ```

2. Create `private/work.zsh` with your work-specific configs:
   ```bash
   touch ~/.config/zsh-environment/private/work.zsh
   # edit it with your work aliases, exports, and functions
   ```

3. Run the install script:
   ```bash
   cd ~/.config/zsh-environment
   chmod +x install.sh check.sh
   ./install.sh
   ```

4. Validate the setup:
   ```bash
   ./check.sh
   ```

5. Open a new terminal.

## Adding new configs

| Type | Where |
|------|-------|
| Generic aliases, functions, exports | `zprofile` or `zshrc` |
| Work-specific configs (internal URLs, company tools, credentials) | `private/work.zsh` only |
