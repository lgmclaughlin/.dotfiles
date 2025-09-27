# setup cache -------------------------------------------------

use_cache=1
cache_folder="$HOME/.cache/wallpaper"

if [ ! -d "$cache_folder" ]; then
    mkdir -p "$cache_folder"
fi

# defaults ----------------------------------------------------

force_generate=0

generatedversions="$cache_folder/wallpaper-generated"
if [ ! -d "$generatedversions" ]; then
    mkdir -p "$generatedversions"
fi

waypaperrunning="$cache_folder/waypaper-running"
if [ -f "$waypaperrunning" ]; then
    rm "$waypaperrunning"
    exit
fi

cachefile="$cache_folder/current_wallpaper"
blurredwallpaper="$cache_folder/blurred_wallpaper.png"
rasifile="$cache_folder/current_wallpaper.rasi"
defaultwallpaper="$HOME/.wallpaper/current_wallpaper.jpg"
blur="50x30"

# get wallpaper -----------------------------------------------

if [ -z "$1" ]; then
    if [ -f "$cachefile" ]; then
        wallpaper=$(cat "$cachefile")
    else
        wallpaper="$defaultwallpaper"
    fi
else
    wallpaper="$1"
fi
used_wallpaper="$wallpaper"
echo "Setting wallpaper with source image $wallpaper"

# copy path of current wallpaper into cache -----------------------------

if [ ! -f "$cachefile" ]; then
    touch "$cachefile"
fi
echo "$wallpaper" > "$cachefile"
echo "Path of current wallpaper copied to $cachefile"

# get wallpaper filename --------------------------------------

wallpaperfilename=$(basename "$wallpaper")
echo "Wallpaper Filename: $wallpaperfilename"

# detect gtk theme --------------------------------------------

SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
THEME_PREF=$(grep -E '^gtk-application-prefer-dark-theme=' "$SETTINGS_FILE" | awk -F'=' '{print $2}')

# run matugen -------------------------------------------------

echo "Execute matugen with $used_wallpaper"
if [ "$THEME_PREF" -eq 1 ]; then
    /usr/bin/matugen image "$used_wallpaper" -m "dark" 
else
    /usr/bin/matugen image "$used_wallpaper" -m "light"
fi

# reload waybar -----------------------------------------------

sleep 1
$HOME/.config/waybar/waybar_init.sh

# update pywalfox ---------------------------------------------

if type pywalfox >/dev/null 2>&1; then
    pywalfox update
fi

# create blurred version --------------------------------------

if [ -f "$generatedversions/blur-$blur-$effect-$wallpaperfilename.png" ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
    echo "Use cached wallpaper blur-$blur-$effect-$wallpaperfilename"
else
    echo "Generate new cached wallpaper blur-$blur-$effect-$wallpaperfilename with blur $blur"
    magick "$used_wallpaper" -resize 75% "$blurredwallpaper"
    echo "Resized to 75%"
    if [ ! "$blur" == "0x0" ]; then
        magick "$blurredwallpaper" -blur "$blur" "$blurredwallpaper"
        cp "$blurredwallpaper" "$generatedversions/blur-$blur-$effect-$wallpaperfilename.png"
        echo "Blurred"
    fi
fi
cp "$generatedversions/blur-$blur-$effect-$wallpaperfilename.png" "$blurredwallpaper"

# create rasi file --------------------------------------------

if [ ! -f "$rasifile" ]; then
    touch "$rasifile"
fi
echo "* { current-image: url(\"$blurredwallpaper\", height); }" > "$rasifile"
