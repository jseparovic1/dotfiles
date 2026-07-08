# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# ZSH SETTINGS
ZSH_THEME="refined"
COMPLETION_WAITING_DOTS="true"

# Plugins
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  git
)

# Load the shell dotfiles, and then some:
for file in ~/.dotfiles/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done

for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi


# SPACESHIP
autoload -U promptinit; promptinit
prompt spaceship

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  user          # Username section
  git           # Git section (git_branch + git_status)
  jobs          # Background jobs indicator
  char          # Prompt character
)

# PATHS
export PATH="$HOME/.symfony/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="$PATH:~/.composer/vendor/bin"
