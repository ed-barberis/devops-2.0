#!/bin/sh -eux
# configure ol7 gnome desktop properties for devops users.

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# start the d-bus user session. ------------------------------------------------
export $(dbus-launch)

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
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-columns "${cols}"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-rows "${rows}"

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
  gsettings set org.gnome.desktop.background picture-uri "file://${pictureuri}"
  gsettings set org.gnome.desktop.background picture-options "${pictureopts}"

  if [ "$USER" = "oracle" ]; then
    gsettings set org.gnome.desktop.background primary-color "${primarycolor}"
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
gsettings set org.gnome.nautilus.icon-view default-zoom-level "${zoomlevel}"

# display updated value.
echo "Displaying updated desktop icon view default zoom level..."
zlevel=$(gsettings get org.gnome.nautilus.icon-view default-zoom-level)
echo "icon-view default-zoom-level: ${zlevel}"
echo ""

# modify desktop icons metadata to enable 'trusted' application launch. --------
# create user desktop directory.
mkdir -p ${HOME}/Desktop

# copy desktop launchers to user desktop folder.
applications_dir="${devops_home}/provisioners/scripts/centos/applications"
if [ -d "${applications_dir}" ]; then
  cd ${applications_dir}

  # process installed application desktops except google chrome browser.
  for desktop_file in $(find . -name '*.desktop' -print | grep -v "google-chrome"); do
    echo ${desktop_file:2}
    cp -f ${desktop_file:2} ${HOME}/Desktop
    chmod 755 ${HOME}/Desktop/${desktop_file:2} 
  done
fi

cd ${HOME}/Desktop

# update the values.
for desktop_file in $(find . -name '*.desktop' -print); do
  gvfs-set-attribute -t string ${desktop_file} "metadata::trusted" "yes"
done

# display updated values.
for desktop_file in $(find . -name '*.desktop' -print); do
  echo "Displaying updated 'metadata' value for: \"${desktop_file:2}\"..."
  gvfs-info -a "metadata::trusted" ${desktop_file}
done
echo ""

# modify gnome shell favorites menu. -------------------------------------------
# retrieve default favorite applications menu and initialize favorite applications menu string.
default_favapps=$(XDG_CONFIG_HOME=/tmp/ gsettings get org.gnome.shell favorite-apps | tr "\n" " ")
def_favapps="${default_favapps:1:-2}"
favapps="[${def_favapps}]"

# declare associative array for installed desktops.
declare -A installed_desktops_array

# if installed devops application desktops exist, sort and create a new
# favorite applications menu string.
if [ -d "${applications_dir}" ]; then
  cd ${applications_dir}

  # split default favorite applications menu string into two parts.
  # part one: the first desktop application launcher filename.
  # part two: all of the other apps from the default favorite applications menu.
  first_index=$(echo "${def_favapps}" | awk '{print index($0, " ")}')
  modified_index=$(($first_index - 4))
  first_app_file="${def_favapps:1:${modified_index}}"
  other_apps="${def_favapps:${first_index}}"

  # copy to include the first desktop application launcher (usually 'firefox.desktop')
  # with the other devops applications.
  if [ -e "/usr/share/applications/${first_app_file}" ]; then
    sudo cp -f /usr/share/applications/${first_app_file} .
    sudo chmod 755 ${first_app_file}
  fi

  # create and populate associative array with installed devops application desktops.
  # note: 'key' is the name attribute of the desktop and the 'value' is the filename.
  for desktop_file in $(find . -name '*.desktop' -print); do
    desktop_name="$(grep "^Name=" ${desktop_file:2} | awk 'NR == 1 {printf "%s", substr($0, 6)}')"
    installed_desktops_array["${desktop_name}"]="${desktop_file:2}"
#   echo "installed_desktops_array[\"${desktop_name}\"]=\"${desktop_file:2}\""
  done

  # after inclusion in associative array, remove first desktop application launcher.
  sudo rm -f ${first_app_file}

  # create a json string of installed desktop filenames sorted by the name attribute.
  # i.e. 'code.desktop' is sorted as 'Name=Visual Studio Code'.
  devops_favapps=$(for desktop_name in "${!installed_desktops_array[@]}"; do
    echo ${desktop_name}:${installed_desktops_array["$desktop_name"]}
  done | sort | awk -F ":" '{printf "\"%s\", ", $2}' | tr '"' "'")

  favapps="[${devops_favapps}${other_apps}]"
fi

echo "favapps: \"${favapps}\""

# display current values.
echo "Displaying current GNOME shell favorites application menu..."
curfavapps=$(gsettings get org.gnome.shell favorite-apps)
echo "favorite-apps (current): ${curfavapps}"
echo ""

# update the values.
gsettings set org.gnome.shell favorite-apps "${favapps}"

# display updated values.
echo "Displaying updated GNOME shell favorites application menu..."
modfavapps=$(gsettings get org.gnome.shell favorite-apps)
echo "favorite-apps (updated): ${modfavapps}"
