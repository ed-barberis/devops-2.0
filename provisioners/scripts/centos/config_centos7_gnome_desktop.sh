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

# modify default desktop background properties (oracle linux only). ------------
distro_name=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '"' | awk '{print $1}')
if [ "$distro_name" = "Oracle" ]; then
  pictureuri="/usr/share/gnome-control-center/pixmaps/noise-texture-light.png"
  pictureopts="wallpaper"
  primarycolor="#880e0e"

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

  if [ "$USER" = "oracle" ]; then
    dbus-launch --exit-with-session gsettings set org.gnome.desktop.background primary-color "${primarycolor}"
  fi

  # display updated values.
  echo "Displaying updated desktop background properties..."
  for bgkey in ${bgkeyarray[@]}; do
    bgvalue=$(gsettings get org.gnome.desktop.background ${bgkey})
    echo "${bgkey}: ${bgvalue}"
  done
  echo ""
fi

# modify default desktop icon view default zoom level. -------------------------
zoomlevel="small"

# display current value.
echo "Displaying current default desktop icon view default zoom level..."
zlevel=$(gsettings get org.gnome.nautilus.icon-view default-zoom-level)
echo "icon-view default-zoom-level: ${zlevel}"
echo ""

# update the value.
dbus-launch --exit-with-session gsettings set org.gnome.nautilus.icon-view default-zoom-level "${zoomlevel}"

# display updated value.
echo "Displaying updated desktop icon view default zoom level..."
zlevel=$(gsettings get org.gnome.nautilus.icon-view default-zoom-level)
echo "icon-view default-zoom-level: ${zlevel}"
echo ""

# modify gnome shell favorites menu. -------------------------------------------
favapps="['firefox.desktop', 'google-chrome.desktop', 'atom.desktop', 'brackets.desktop', 'postman.desktop', 'scala-ide-for-eclipse.desktop', 'spring-tool-suite.desktop', 'sublime_text.desktop', 'code.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'yelp.desktop', 'gnome-terminal.desktop']"

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
