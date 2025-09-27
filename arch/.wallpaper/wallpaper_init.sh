# set vars ----------------------------------------------------

cache_folder="$HOME/.cache/wallpaper"
cachefile="$cache_folder/current_wallpaper"
defaultwallpaper="$HOME/.wallpaper/current_wallpaper.jpg"
usecache=0

# get current wallpaper ---------------------------------------

if [ -f "$cachefile" ] && [ "$usecache" == "1" ]; then
    sed -i "s|~|$HOME|g" "$cachefile"
    wallpaper=$(cat $cachefile)
    if [ -f $wallpaper ]; then
        echo ":: Wallpaper $wallpaper exists"
    else
        echo ":: Wallpaper $wallpaper does not exist. Using default."
        wallpaper=$defaultwallpaper
    fi
else
    if [ "$usecache" == "0" ]; then
        echo ":: Caching turned off. Using default wallpaper."
    else
        echo ":: $cachefile does not exist. Using default wallpaper."
    fi
    wallpaper=$defaultwallpaper
fi

# set wallpaper -----------------------------------------------

if [ -x /usr/bin/waypaper ]; then
	case ":$PATH:" in
		*":/usr/bin:"*) ;;
		*) export PATH="$PATH:/usr/bin" ;;
	esac
else
	echo "Error: waybar not installed."
	exit 1
fi
waypaper --wallpaper "$wallpaper"
