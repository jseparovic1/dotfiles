#!/bin/bash
#
# Symlink the canonical AGENTS.md into every AI coding harness on this machine.
# Each harness reads a differently-named file, but they all point at the same
# source of truth so instructions stay in sync:
#
#   agents/AGENTS.md -> ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md, ~/AGENTS.md, ...
#
# Safe to re-run: existing regular files are backed up to <file>.bak, and stale
# symlinks are replaced.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$DOTFILES_DIR/agents/AGENTS.md"

# Where AGENTS.md gets linked - the primary instruction file each harness reads.
# Add new harnesses here.
AGENTS_TARGETS=(
	"$HOME/.claude/CLAUDE.md"   # Claude Code
	"$HOME/.codex/AGENTS.md"    # Codex
	"$HOME/.config/AGENTS.md"   # generic / XDG
	"$HOME/AGENTS.md"           # bare home fallback
)

# link SOURCE TARGET - idempotent, backs up real files, replaces stale links.
link() {
	local source="$1" target="$2" dir
	dir="$(dirname "$target")"
	mkdir -p "$dir"

	if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
		echo "ok      $target"
		return
	fi

	if [[ -e "$target" && ! -L "$target" ]]; then
		mv "$target" "$target.bak"
		echo "backup  $target -> $target.bak"
	fi

	ln -sf "$source" "$target"
	echo "linked  $target -> $source"
}

echo 'Symlink AGENTS.md into harnesses'
echo '--------------------------------'

[[ -f "$AGENTS_SRC" ]] || { echo "error: $AGENTS_SRC not found" >&2; exit 1; }

for target in "${AGENTS_TARGETS[@]}"; do
	link "$AGENTS_SRC" "$target"
done

echo 'Done!'
