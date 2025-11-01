#!/usr/bin/env bash
set -euo pipefail

# Build keymap cache for keycode translation
build_keymap_cache() {
  local keymap
  keymap=$(xkbcli compile-keymap 2>/dev/null)

  echo "$keymap" | awk '
    /xkb_keycodes/,/\};/ {
      if (match($0, /<([A-Z0-9]+)> *= *([0-9]+)/, arr)) {
        print arr[2] " " arr[1]
      }
    }
  '
}

# Translate modmask number to readable modifiers
translate_modmask() {
  local modmask=$1
  local result=""

  # Check each modifier bit
  if ((modmask & 64)); then result="${result}SUPER "; fi
  if ((modmask & 4)); then result="${result}CTRL "; fi
  if ((modmask & 8)); then result="${result}ALT "; fi
  if ((modmask & 1)); then result="${result}SHIFT "; fi

  # Trim trailing space and return
  echo "${result% }"
}

# Resolve keycode to symbol
resolve_keycode() {
  local key=$1
  local keymap_cache=$2

  # If it's a keycode (code:XX), translate it
  if [[ "$key" =~ ^code:([0-9]+)$ ]]; then
    local keycode="${BASH_REMATCH[1]}"
    local symbol
    symbol=$(echo "$keymap_cache" | awk -v code="$keycode" '$1 == code {print $2; exit}')

    if [[ -n "$symbol" ]]; then
      echo "$symbol"
    else
      echo "$key"
    fi
  else
    echo "$key"
  fi
}

# Priority for sorting (lower = higher priority)
get_priority() {
  local desc=$1

  case "$desc" in
    # Tier 1: Most common actions (10)
    Terminal*|Browser*|*launcher*|*menu*|*manager*|Gmail*|*Calendar*|*Drive*|NotebookLM*|Readwise*|*p5.js*|YouTube*|Obsidian*|Spotify*) echo 10 ;;

    # Tier 2: Window management essentials (20)
    "Close window"|"Toggle floating"|Fullscreen|"Next window"|"Previous window") echo 20 ;;

    # Tier 3: Workspace navigation (30)
    Workspace*|"Next workspace"|"Previous workspace"|"Last workspace"|"Move to workspace"*) echo 30 ;;

    # Tier 4: Window organization (40)
    Focus*|Swap*|"Grow window"*|"Toggle split"*) echo 40 ;;

    # Tier 5: Screenshots & capture (50)
    Screenshot*|*picker*) echo 50 ;;

    # Tier 6: Advanced window management (60)
    *group*) echo 60 ;;

    # Tier 7: Media & system controls (70)
    Volume*|Brightness*|Play*|*track*|Mute*) echo 70 ;;

    # Tier 8: Less common (80)
    *wallpaper*|"Switch keyboard"*|Pseudo*|"Close all"*) echo 80 ;;

    # Default (50)
    *) echo 50 ;;
  esac
}

main() {
  local keymap_cache
  keymap_cache=$(build_keymap_cache)

  local bindings
  bindings=$(hyprctl binds -j)

  # Process bindings
  echo "$bindings" | jq -r '.[] | select(.has_description == true) |
    [.modmask, .key, .description] | @tsv' | while IFS=$'\t' read -r modmask key desc; do

    # Translate modifiers
    local mods
    mods=$(translate_modmask "$modmask")

    # Resolve keycode
    local resolved_key
    resolved_key=$(resolve_keycode "$key" "$keymap_cache")

    # Format the keybinding
    local keybind
    if [[ -n "$mods" ]]; then
      keybind="$mods + $resolved_key"
    else
      keybind="$resolved_key"
    fi

    # Get priority for sorting
    local priority
    priority=$(get_priority "$desc")

    # Output: priority | formatted_keybind → description
    printf "%d\t%s → %s\n" "$priority" "$keybind" "$desc"
  done | sort -n | cut -f2- | walker --dmenu --width 600 --height 800 -p "Keybindings"
}

main
