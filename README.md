# dotfiles

My personal macOS dotfiles: shell config, aliases, macOS defaults, and shared AI agent instructions.
Built for Apple Silicon with Homebrew at `/opt/homebrew`.

## Layout

```
.
├── agents/
│   └── AGENTS.md        # global AI agent instructions (Claude, Codex, ...)
├── shell/
│   ├── .zshrc                 # zsh + oh-my-zsh + starship setup
│   ├── .aliases               # git, docker, composer, laravel shortcuts
│   ├── .global-gitignore
│   ├── .tmux.conf             # tmux mouse, copy-mode, status bar
│   ├── statusline-command.sh  # Claude Code statusline
│   ├── starship.toml          # prompt config
│   ├── phpstorm               # `phpstorm .` launcher
│   └── Snazzy.itermcolors
├── macos/
│   └── defaults.sh      # opinionated macOS system defaults
├── .ssh/
│   └── config           # ssh host config (no keys)
├── install.sh           # installs tools + symlinks everything
├── bootstrap.sh         # confirmation wrapper around install.sh
└── symlink-agents.sh    # links agents/AGENTS.md into each AI harness
```

## Install

Clone the repo, then run the bootstrap script:

```sh
git clone https://github.com/jseparovic1/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./bootstrap.sh
```

`bootstrap.sh` asks for confirmation and then runs `install.sh`, which is idempotent and safe to re-run.

## What install.sh does

- Installs Homebrew (if missing) and oh-my-zsh.
- Installs packages via Homebrew: `pkg-config`, `wget`, `starship`, `zsh-autosuggestions`, `composer`, `node@22`.
- Symlinks the repo to `~/.dotfiles` so `.zshrc` can reference `$DOTFILES` from a stable path.
- Symlinks `~/.zshrc`, `~/.aliases`, `~/.global-gitignore`, `~/.tmux.conf`, and `~/.ssh/config`.
- Symlinks `~/.claude/statusline-command.sh` (Claude Code statusline).
- Installs the `phpstorm` launcher into `~/.local/bin`.
- Runs `symlink-agents.sh` to wire up the AI agent instructions.

Existing real files are backed up to `<file>.bak` before being replaced by a symlink.

## Agent instructions

`agents/AGENTS.md` is the single source of truth for how AI coding agents should behave.
`symlink-agents.sh` links it into every harness under the name each one expects, so one edit updates them all:

| Harness | Path |
| --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| Generic / XDG | `~/.config/AGENTS.md` |
| Home fallback | `~/AGENTS.md` |

To add another harness, append its path to `AGENTS_TARGETS` in `symlink-agents.sh` and re-run it.

## macOS defaults

`macos/defaults.sh` applies system tweaks (Finder, Dock, keyboard, screenshots, and more).
Review it before running, since it changes a lot of settings and some require a logout or restart:

```sh
./macos/defaults.sh
```
