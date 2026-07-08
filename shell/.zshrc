# Path to your dotfiles (~/.dotfiles is symlinked to this repo by install.sh).
export DOTFILES="$HOME/.dotfiles"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$DOTFILES/shell/custom"

# Homebrew (Apple Silicon). Puts brew on PATH before anything else needs it.
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# oh-my-zsh
ZSH_THEME=""                       # prompt is handled by starship below
COMPLETION_WAITING_DOTS="true"
plugins=(git)                      # must be set before sourcing oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# zsh-autosuggestions (installed via brew)
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
	source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Load the shell dotfiles, and then some:
for file in "$DOTFILES"/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Starship prompt
if command -v starship >/dev/null 2>&1; then
	export STARSHIP_CONFIG="$DOTFILES/shell/starship.toml"
	eval "$(starship init zsh)"
fi

# Composer global bin
export PATH="$HOME/.composer/vendor/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Herd injected PHP binary + config
export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ~/.local/bin (Droid, Antigravity CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"
