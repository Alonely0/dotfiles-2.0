#!/bin/bash

# Kill polybar
killall -q polybar

# Await polybar processes to finish
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# execute Polybar in all screens
if type "xrandr"; then
  sleep 1;
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi

echo "Polybar launched..."
