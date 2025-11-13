#!/usr/bin/env bash

# Monitor Hyprland events and reload hyprpaper when monitors are added
# This script listens to Hyprland's IPC socket for monitoradded events

SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Check if socket exists
if [[ ! -S "$SOCKET_PATH" ]]; then
  echo "Error: Hyprland socket not found at $SOCKET_PATH" >&2
  exit 1
fi

# Listen to Hyprland events
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
  # Check for monitoradded event
  if [[ "$line" == monitoradded* ]]; then
    echo "Monitor added detected, reloading hyprpaper..."

    # Kill and restart hyprpaper
    pkill hyprpaper
    sleep 0.5
    hyprpaper &

    # Restore wallpaper configuration
    sleep 1
    waypaper --restore
  fi
done
