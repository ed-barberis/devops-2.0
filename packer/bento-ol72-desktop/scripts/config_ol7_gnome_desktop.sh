#!/bin/sh -eux
# configure ol7 gnome desktop properties for devops users.

# modify default terminal column and row size. ---------------------------------
cols="128"
rows="34"

# retrieve default terminal profile id.
defprofileid=$(gsettings get org.gnome.Terminal.ProfilesList default)

# display current values.
echo "Displaying current default terminal column and row size..."
curcols=$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-columns)
currows=$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-rows)
echo "default-size-columns (current): ${curcols}"
echo "default-size-rows (current): ${currows}"
echo ""

# update the values.
dbus-launch --exit-with-session gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-columns "${cols}"
dbus-launch --exit-with-session gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-rows "${rows}"

# display updated values.
echo "Displaying updated default terminal column and row size..."
modcols=$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-columns)
modrows=$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-rows)
echo "default-size-columns (updated): ${modcols}"
echo "default-size-rows (updated): ${modrows}"
echo ""

# modify default desktop background properties. --------------------------------
pictureuri="/usr/share/gnome-control-center/pixmaps/noise-texture-light.png"
pictureopts="wallpaper"

# display current values.
echo "Displaying current default desktop background properties..."
bgkeylist=$(gsettings list-keys org.gnome.desktop.background)
bgkeyarray=( $bgkeylist )

for bgkey in ${bgkeyarray[@]}; do
  bgvalue=$(gsettings get org.gnome.desktop.background ${bgkey})
  echo "${bgkey}: ${bgvalue}"
done
echo ""

# update the values.
dbus-launch --exit-with-session gsettings set org.gnome.desktop.background picture-uri "file://${pictureuri}"
dbus-launch --exit-with-session gsettings set org.gnome.desktop.background picture-options "${pictureopts}"

# display updated values.
echo "Displaying updated desktop background properties..."
for bgkey in ${bgkeyarray[@]}; do
  bgvalue=$(gsettings get org.gnome.desktop.background ${bgkey})
  echo "${bgkey}: ${bgvalue}"
done
echo ""

# modify gnome shell favorites menu. -------------------------------------------
favapps="['firefox.desktop', 'google-chrome.desktop', 'postman.desktop', 'atom.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'yelp.desktop', 'gnome-terminal.desktop']"

# display current values.
echo "Displaying current GNOME shell favorites application menu..."
curfavapps=$(gsettings get org.gnome.shell favorite-apps)
echo "favorite-apps (current): ${curfavapps}"
echo ""

# update the values.
dbus-launch --exit-with-session gsettings set org.gnome.shell favorite-apps "${favapps}"

# display updated values.
echo "Displaying updated GNOME shell favorites application menu..."
modfavapps=$(gsettings get org.gnome.shell favorite-apps)
echo "favorite-apps (updated): ${modfavapps}"
