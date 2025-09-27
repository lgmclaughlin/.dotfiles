# config ------------------------------------------------------

cache_folder="$HOME/.cache/wallpaper"
sec=60
notify=0

# set random --------------------------------------------------

_setWallpaperRandomly() {
    waypaper --random
    echo ":: Next wallpaper in $sec seconds..."
    sleep $sec
    _setWallpaperRandomly
}

if [ ! -f $cache_folder/wallpaper-automation ]; then
    touch $cache_folder/wallpaper-automation
    echo ":: Start wallpaper automation script"
    if [ "$notify" == "1" ]; then
    	notify-send "Wallpaper automation process started" "Wallpaper will be changed every $sec seconds."
    fi
    _setWallpaperRandomly
else
    rm $cache_folder/wallpaper-automation
    if [ "$notify" == "1" ]; then
    	notify-send "Wallpaper automation process stopped."
    fi
    echo ":: Wallpaper automation script process $wp stopped"
    wp=$(pgrep -f wallpaper-automation.sh)
    kill -KILL $wp
fi
