#!/bin/bash
input=$(cat)

# Colors (ANSI-C quoting embeds real ESC byte)
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
BLUE=$'\033[34m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
MAGENTA=$'\033[35m'
ORANGE=$'\033[38;5;208m'

# Parse input
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
# Drop parenthetical suffix, e.g. "Opus 4.8 (1M context)" -> "Opus 4.8"
model="${model% (*}"
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

# Shorten home to ~
short_dir="${dir/#$HOME/~}"

# Git branch + dirty indicator
git_info=""
if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$dir" -c core.useBuiltinFSMonitor=false symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -n "$(git -C "$dir" -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)" ]; then
            git_info=" ${YELLOW} ${branch}*${RESET}"
        else
            git_info=" ${GREEN} ${branch}${RESET}"
        fi
    fi
fi

# Context: color shifts by absolute tokens — green <60k, yellow <100k, orange <150k, red ≥150k
used_int=$(printf '%.0f' "$used_pct")
used_tok_int=""
[ -n "$used_tokens" ] && used_tok_int=$(printf '%.0f' "$used_tokens")
if [ -z "$used_tok_int" ]; then
    ctx_color="$GREEN"
elif [ "$used_tok_int" -lt 60000 ]; then
    ctx_color="$GREEN"
elif [ "$used_tok_int" -lt 100000 ]; then
    ctx_color="$YELLOW"
elif [ "$used_tok_int" -lt 150000 ]; then
    ctx_color="$ORANGE"
else
    ctx_color="$RED"
fi

# Token count in "k" (1 decimal under 10k, whole k otherwise)
ctx_tok=""
if [ -n "$used_tok_int" ]; then
    if [ "$used_tok_int" -lt 10000 ]; then
        ctx_tok=$(awk "BEGIN{printf \"%.1fk\", $used_tok_int/1000}")
    else
        ctx_tok=$(awk "BEGIN{printf \"%.0fk\", $used_tok_int/1000}")
    fi
    ctx_display="${ctx_tok} (${used_int}%)"
else
    ctx_display="${used_int}%"
fi

# Dumb-zone alert: fires on absolute tokens (60k–150k), regardless of window size
dumb_alert=""
if [ -n "$used_tok_int" ] && [ "$used_tok_int" -ge 60000 ] && [ "$used_tok_int" -le 150000 ]; then
    dumb_alert=" ${DIM}|${RESET} ${BOLD}${RED} DUMB ZONE${RESET}"
fi

printf "%s ${DIM}|${RESET} ${ctx_color}%s${RESET} ${DIM}|${RESET} ${MAGENTA}%s${RESET}%s" \
    "${git_info# }" "$ctx_display" "$model" "$dumb_alert"
