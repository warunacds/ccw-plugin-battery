#!/bin/sh
# battery plugin for ccstatuswidgets
# Shows laptop battery level and charging status

# Consume stdin (plugin protocol requires reading it)
cat > /dev/null

# Detect OS and read battery info
percent=""
charging=""

case "$(uname -s)" in
  Darwin)
    batt_info=$(pmset -g batt 2>/dev/null)
    if [ -z "$batt_info" ]; then
      exit 0
    fi
    # Extract percentage (e.g., "78%")
    percent=$(echo "$batt_info" | grep -o '[0-9]*%' | head -1 | tr -d '%')
    # Check charging status
    if echo "$batt_info" | grep -q 'AC Power'; then
      if echo "$batt_info" | grep -q 'charging'; then
        charging="yes"
      elif echo "$batt_info" | grep -q 'charged'; then
        charging="yes"
      fi
    fi
    ;;
  Linux)
    cap_file="/sys/class/power_supply/BAT0/capacity"
    status_file="/sys/class/power_supply/BAT0/status"
    if [ ! -f "$cap_file" ]; then
      exit 0
    fi
    percent=$(cat "$cap_file" 2>/dev/null)
    status=$(cat "$status_file" 2>/dev/null)
    if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
      charging="yes"
    fi
    ;;
  *)
    # Unsupported OS, output nothing
    exit 0
    ;;
esac

# No battery detected
if [ -z "$percent" ]; then
  exit 0
fi

# Determine color based on percentage
if [ "$percent" -ge 50 ]; then
  color="green"
elif [ "$percent" -ge 20 ]; then
  color="yellow"
else
  color="red"
fi

# Build display text
if [ -n "$charging" ]; then
  icon="⚡"
else
  if [ "$percent" -lt 20 ]; then
    icon="🪫"
  else
    icon="🔋"
  fi
fi

printf '{"text":"%s %d%%","color":"%s"}\n' "$icon" "$percent" "$color"
