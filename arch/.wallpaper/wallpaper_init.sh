# start swww --------------------------------------------------

swww init
swww-daemon --format xrgb
sleep 0.5

# load image --------------------------------------------------

swww img ~/.wallpaper/wallpaper.png --transition-type=inner --transition-duration=5
