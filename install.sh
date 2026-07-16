#!/bin/bash
#
# Installs and symlinks everything. Idempotent - safe to re-run.
# Built for macOS on Apple Silicon (Homebrew at /opt/homebrew), but the brew
# prefix is detected so it also works on Intel (/usr/local).

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link SRC TARGET - back up an existing real file, then symlink.
link() {
	local src="$1" target="$2"
	if [[ -e "$target" && ! -L "$target" ]]; then
		mv "$target" "$target.bak"
		echo "backup  $target -> $target.bak"
	fi
	ln -sf "$src" "$target"
	echo "linked  $target -> $src"
}

# Hide "last login" line when starting a new terminal session
touch "$HOME/.hushlogin"

echo 'Install Homebrew'
echo '----------------'
if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Prefer Apple Silicon's /opt/homebrew, fall back to Intel's /usr/local, then PATH.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew "$(command -v brew)"; do
	[ -x "$brew_bin" ] && break
done
eval "$("$brew_bin" shellenv)"

echo 'Install oh-my-zsh'
echo '-----------------'
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	RUNZSH=no CHSH=no \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo 'Install packages'
echo '----------------'
brew install \
	pkg-config \
	wget \
	starship \
	zsh-autosuggestions \
	composer \
	node@22

echo 'Symlink dotfiles into ~/.dotfiles'
echo '---------------------------------'
link "$DOTFILES_DIR" "$HOME/.dotfiles"

echo 'Symlink shell config'
echo '--------------------'
link "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/shell/.aliases" "$HOME/.aliases"
link "$DOTFILES_DIR/shell/.global-gitignore" "$HOME/.global-gitignore"
link "$DOTFILES_DIR/shell/.tmux.conf" "$HOME/.tmux.conf"
git config --global core.excludesfile "$HOME/.global-gitignore"

echo 'Symlink Claude Code statusline'
echo '------------------------------'
mkdir -p "$HOME/.claude"
link "$DOTFILES_DIR/shell/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

echo 'Symlink ssh config'
echo '------------------'
mkdir -p "$HOME/.ssh"
link "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"

echo 'Install phpstorm launcher'
echo '-------------------------'
mkdir -p "$HOME/.local/bin"
install -m 0755 "$DOTFILES_DIR/shell/phpstorm" "$HOME/.local/bin/phpstorm"

echo 'Symlink agent files into AI harnesses'
echo '-------------------------------------'
source "$DOTFILES_DIR/symlink-agents.sh"

echo '++++++++++++++++++++++++++++++'
echo 'All done! Restart your shell or run: source ~/.zshrc'
