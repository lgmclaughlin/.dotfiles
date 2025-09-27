# check usage -------------------------------------------------

if [ -z "$1" ]; then
	echo "Missing filename arg."
	exit 1
fi

# vars --------------------------------------------------------

filename="$1"
wallpaper_folder="$HOME/.wallpaper"
options_folder="$wallpaper_folder/options"
current_wallpaper="$wallpaper_folder/current_wallpaper.jpg"

# check option exists -----------------------------------------

if [ ! -f "$options_folder/$filename" ]; then
	echo "Chosen wallpaper doesn't exist."
	exit 1
fi

# copy option -------------------------------------------------

cp -f "$options_folder/$filename" "$current_wallpaper"

if [ -x /usr/bin/waypaper ]; then
	case ":$PATH:" in
		*":/usr/bin:"*) ;;
		*) export PATH="$PATH:/usr/bin" ;;
	esac
else
	echo "Error: waybar not installed."
	exit 1
fi
waypaper --wallpaper "$current_wallpaper"
