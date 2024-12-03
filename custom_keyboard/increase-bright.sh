#!/bin/bash
xrandr --output DP-3-1 --brightness $(bc -l <<< "scale=2; $(xrandr --verbose | grep DP-3-1 -A 5 | awk '/Brightness/ { print $2; exit }') + 0.1") &
xrandr --output DP-1 --brightness $(bc -l <<< "scale=2; $(xrandr --verbose | grep DP-3-1 -A 5 | awk '/Brightness/ { print $2; exit }') + 0.1") &
