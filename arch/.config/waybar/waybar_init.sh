# lock --------------------------------------------------------

exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

# clear instances----------------------------------------------

killall waybar || true
pkill waybar || true
sleep 0.5	

# find hyprland instance and inject ---------------------------

HYPRLAND_SIGNATURE=$(hyprctl instances -j | jq -r '.[0].instance')
HYPRLAND_INSTANCE_SIGNATURE="$HYPRLAND_SIGNATURE" waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &

# unlock ------------------------------------------------------

flock -u 200
exec 200>$-
