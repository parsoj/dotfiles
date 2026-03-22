#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
model_id=$(echo "$input" | jq -r '.model.id')
dir=$(echo "$input" | jq -r '.workspace.current_dir')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.total_cost_usd // 0')
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Colors
reset="\033[0m"
bold="\033[1m"
dim="\033[2m"
cyan="\033[36m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"
blue="\033[34m"
magenta="\033[35m"
purple="\033[38;5;135m"

# Model name color based on model
if echo "$model_id" | grep -qi "opus"; then
  model_color="$purple"
elif echo "$model_id" | grep -qi "haiku"; then
  model_color="$yellow"
else
  model_color="$cyan"
fi

# Line 1: Model + Context bar
if [ -n "$used" ]; then
  bar_length=20
  filled=$(printf "%.0f" "$(echo "$used * $bar_length / 100" | bc -l)")
  empty=$((bar_length - filled))

  # Color based on usage threshold
  if [ "$(echo "$used < 60" | bc)" -eq 1 ]; then
    bar_color="$green"
  elif [ "$(echo "$used < 85" | bc)" -eq 1 ]; then
    bar_color="$yellow"
  else
    bar_color="$red"
  fi

  bar=""
  [ "$filled" -gt 0 ] && bar=$(printf '█%.0s' $(seq 1 "$filled"))
  [ "$empty" -gt 0 ] && bar="${bar}$(printf '░%.0s' $(seq 1 "$empty"))"

  printf "${bold}${model_color}%s${reset}  ${dim}│${reset}  Context: ${bar_color}%s %3.0f%%${reset}\n" "$model" "$bar" "$used"
else
  printf "${bold}${model_color}%s${reset}  ${dim}│${reset}  Context: ${dim}N/A${reset}\n" "$model"
fi

# Line 2: Directory + Cost + Git branch
line2=$(printf "${blue}%s${reset}" "$dir")

if [ "$(echo "$cost > 0" | bc)" -eq 1 ]; then
  cost_fmt=$(printf "$%.2f" "$cost")
  line2="${line2}  ${dim}│${reset}  ${magenta}${cost_fmt}${reset}"
fi

if [ -n "$branch" ]; then
  line2="${line2}  ${dim}│${reset}  ${green}${branch}${reset}"
fi

printf "${line2}\n"
