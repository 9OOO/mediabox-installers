#!/bin/bash

# Hama Bundle and Absolute Series Scanner Installer/Updater by Liara#9557 and Xan#7777
# Reworked for Whatbox

plugindir=$HOME/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/
scannerdir=$HOME/Library/Application\ Support/Plex\ Media\ Server/Scanners/Series
supportdir=$HOME/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Data/com.plexapp.agents.hama/DataItems/

if [ ! -d "$HOME/.config/plex/" ];
then
    echo "Plex is not installed. Exiting..."
    exit
fi

if [[ -f "$scannerdir/Absolute Series Scanner.py" && -d "$supportdir" && -d "$plugindir/Hama.bundle" ]];
then
  echo "HAMA Found. Upgrading..."
  cd "$plugindir/Hama.bundle/" || exit
  git pull
  rm -rf "$scannerdir/Absolute Series Scanner.py"
  wget -O "$scannerdir/Absolute Series Scanner.py" https://raw.githubusercontent.com/ZeroQI/Absolute-Series-Scanner/master/Scanners/Series/Absolute%20Series%20Scanner.py
  echo "HAMA Upgraded."
  echo "Restart plex to finish"
  exit
else
  echo "Installing HAMA..."
  mkdir -p "$scannerdir"
  cd "$plugindir" || exit
  git clone https://github.com/ZeroQI/Hama.bundle.git
  wget -O "$scannerdir/Absolute Series Scanner.py" https://raw.githubusercontent.com/ZeroQI/Absolute-Series-Scanner/master/Scanners/Series/Absolute%20Series%20Scanner.py
  for s in AniDB Plex OMDB TMDB TVDB/blank TVDB/_cache/fanart/original TVDB/episodes TVDB/fanart/original TVDB/fanart/vignette TVDB/graphical TVDB/posters TVDB/seasons TVDB/seasonswide TVDB/text FanartTV; do
    mkdir -p "${supportdir}${s}"
  done
  echo "HAMA installed."
  echo "Restart plex to finish"
  exit
fi