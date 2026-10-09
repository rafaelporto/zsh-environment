# ZSH Environment

Personal ZSH configuration files for macOS and Linux.

## Structure

```
zsh-environment/
├── zshrc          # Interactive shell config (Oh My Zsh, plugins, theme, tools, aliases, functions)
├── zprofile       # Login profile (PATH and environment exports only)
├── p10k.zsh       # Powerlevel10k theme configuration
├── p10k-tty.zsh   # p10k overrides for the Linux console — opt-in, not symlinked (see below)
├── tty-theme.zsh  # Linux console color palette + `ttytheme` command — not symlinked (see below)
├── setup.sh       # One-shot setup: dependencies + symlinks + validation
├── bootstrap.sh   # Installs required dependencies
├── install.sh     # Sets up symlinks from ~/ to this repo
├── check.sh       # Validates the installation
└── private/       # Per-machine files — gitignored, never committed
    ├── work.zsh   # Work-specific configs, created manually on each machine (see below)
    └── machine.zsh # Optional machine settings, e.g. the TTY prompt and theme (see below)
```

## How it works

`setup.sh` is the single entry point for a new machine: it installs dependencies, creates symlinks, and validates the setup. Internally it calls `bootstrap.sh`, `install.sh`, and `check.sh` in sequence — each of which can also be run independently.

`install.sh` replaces `~/.zshrc`, `~/.zprofile`, and `~/.p10k.zsh` with symlinks pointing to this repo. Any change committed here takes effect immediately in new terminal sessions.

`check.sh` validates the installation: confirms that the symlinks point to the correct files, that `private/` is set up correctly, that no private files are tracked by git, and that `zshrc` and `zprofile` have no syntax errors.

Work-specific configuration lives in `private/work.zsh`, which is sourced at the end of `zshrc` if the file exists. This file is gitignored and must be created manually on each machine — it is never tracked by this repository.

Machine settings live in `private/machine.zsh`, also gitignored and optional. Unlike `work.zsh`, it holds no secrets — only switches that describe the hardware or terminal of that machine. It is sourced **before** the Powerlevel10k block, so its switches can change how the prompt is loaded.

## Linux console (TTY) prompt

The Linux console (the text VT on a headless machine's monitor, `TERM=linux`) only loads bitmap fonts of up to 512 glyphs, so Nerd Font icons and symbols such as `❯` and `✔` cannot be drawn there. `p10k-tty.zsh` overrides the prompt with ASCII equivalents (`POWERLEVEL9K_MODE=ascii`, `>` / `<` as the prompt char, `ok` for success).

It is loaded by `zshrc` only when **all three** conditions hold:

1. The OS is Linux (`$OSTYPE == linux-gnu*`) — macOS never loads it.
2. The machine opted in with `ZSH_ENV_TTY_PROMPT=1` in `private/machine.zsh`.
3. The terminal is the console: `TERM=linux`, or — inside tmux, where `TERM` belongs to tmux — the attached client's `#{client_termname}` is `linux`.

To enable it on a machine:

```bash
echo 'ZSH_ENV_TTY_PROMPT=1' >> ~/.config/zsh-environment/private/machine.zsh
```

The console has only 8 colors. Outside tmux, zsh knows it (`TERM=linux`) and skips the 256-color greys of `p10k.zsh`, so they render as the default white. Inside tmux, `TERM` claims 256 colors and tmux rounds those greys down to black — invisible on the black background. So, in a tmux pane opened from the console, `zshrc` also sets `TERM=tmux` (8 colors); programs started from that pane (nvim, lazygit) see 8 colors as well.

The choice is made when the shell starts: a tmux pane opened over SSH keeps the Nerd Font prompt when later viewed on the console, and vice versa. Open a new pane (or `exec zsh`) to switch. The git ahead/behind arrows (`⇣⇡⇠⇢`) are hardcoded in `p10k.zsh`'s formatter and still show as `?` on the console.

For accented characters and box drawing to render, the console font must be a Unicode one — on Debian, set `CODESET="Uni3"`, `FONTFACE="Terminus"` and `FONTSIZE` in `/etc/default/console-setup`, then run `sudo setupcon`.

### Console color theme (`ttytheme`)

The console's 16 colors can be re-tinted without root, through `\e]P<index><RRGGBB>` escape sequences (`\e]R` restores the kernel default). `tty-theme.zsh` ships a light palette (One Light) and the `ttytheme` command, defined on Linux only:

```bash
ttytheme light   # apply the light palette now and save it as this machine's default
ttytheme dark    # restore the kernel palette now and drop the saved default
ttytheme         # show the saved theme
```

Saving means one line in `private/machine.zsh` (`ZSH_ENV_TTY_THEME=light`); the command rewrites only that line. Nothing changes on a machine until someone runs `ttytheme` there — a fresh clone gets the command, never the theme.

- **Inside tmux** it works too: tmux does not forward `\e]P`, so `ttytheme` writes straight to the attached client's tty (`#{client_tty}`), as long as that client is the console. Anywhere else (e.g. plain SSH) it refuses with a warning.
- **On login**, `zshrc` re-applies the saved theme when the shell runs directly on the console (`TERM=linux`, outside tmux). The palette lasts until logout or reboot, and a tmux started from that shell inherits it.
- It is independent of `ZSH_ENV_TTY_PROMPT`: either can be enabled without the other.

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

These tools are not required. If installed, their aliases are automatically activated in `zshrc`. If not installed, they are silently skipped.

| Tool | Purpose | Aliases | Config |
|------|---------|---------|--------|
| `kitty` | Terminal emulator | `kittytheme`, `nvkitty`, `updateKitty` | [kitty-config](https://github.com/rafaelporto/kitty-config) ¹ |
| `dotnet` | .NET SDK | `dn`, `dnb`, `dnr`, `dnc`, `dnrt`, `dnt` | — |
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
| Aliases and shell functions | `zshrc` |
| Environment exports (`PATH`, `*_HOME`, ...) | `zprofile` |
| Work-specific configs (internal URLs, company tools, credentials) | `private/work.zsh` only |
| Machine switches (hardware/terminal of one machine, no secrets) | `private/machine.zsh` (`ttytheme` edits it for you) |

> Aliases and functions **must** live in `zshrc`. They are not part of the environment, so they are not
> inherited by child processes — defining them in `zprofile` makes them reach login shells only, and they
> silently vanish in every non-login terminal (LXDE's lxterminal, tmux panes, most Linux emulators).
