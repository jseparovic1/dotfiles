#!/bin/bash
#
# bootstrap installs things.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'Bootstrap terminal'
echo '------------------'
read -p 'This will set up your terminal and symlink dotfiles. Continue? (y/n) ' reply

if [[ $reply =~ ^[Yy]$ ]]; then
	sudo -v # ask for password upfront
	bash "$DOTFILES_DIR/install.sh"
fi
