#!/usr/bin/env bash
set -euo pipefail

BACK_TO_EXIT=false

back_to() {
  local parent_menu="${1:-}"

  if [[ "$BACK_TO_EXIT" == "true" ]]; then
    exit 0
  elif [[ -n "$parent_menu" ]]; then
    "$parent_menu"
  else
    show_main_menu
  fi
}

menu() {
  local prompt="${1:-}"
  local options="${2:-}"
  local extra="${3:-}"
  local preselect="${4:-}"

  read -r -a args <<<"$extra"

  if [[ -n "$preselect" ]]; then
    local index
    index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
    if [[ -n "$index" ]]; then
      args+=("-c" "$index")
    fi
  fi

  echo -e "$options" | walker --dmenu --width 295 --height 600 -p "$prompt..." "${args[@]}"
}

terminal() {
  alacritty --class=Niflheim -e "$@"
}

show_capture_menu() { 
  case $(menu "Capture" "󰹑  Grab the whole screen\n  Grab the current window\n󰗆  Grab an area\n  Grab a colour") in
  *area*) take-screenshot area ;;
  *window*) take-screenshot active ;;
  *screen*) take-screenshot output ;;
  *colour*)
    if pgrep -x hyprpicker >/dev/null; then
      pkill hyprpicker
    else
      hyprpicker -a
    fi
    ;;
  *) back_to show_main_menu ;;
  esac
}

show_system_menu() {
  case $(menu "System" "  Lock\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
  *Lock*) hyprlock ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot --no-wall ;;
  *Shutdown*) systemctl poweroff --no-wall ;;
  *) back_to show_main_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n  Capture\n  About\n  System")"
}

go_to_menu() {
  case "${1,,}" in
    *apps*) walker -p "Launch..." ;;
    *capture*) show_capture_menu ;;
    *about*) launch-about ;;
    *system*) show_system_menu ;;
  esac
}

if [[ -n "${1:-}" ]]; then
  BACK_TO_EXIT=true
  go_to_menu "$1"
else
  show_main_menu
fi
