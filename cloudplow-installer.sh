#!/bin/bash

# Cloudplow Installer/Updater Script by Xan#7777

# Run the following commands before running this
# curl https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/deluge-rtorrent/pip-install.sh | bash && exit

if [ ! -d "$HOME/cloudplow" ];
then
    echo "Installing cloudplow..."
    git clone https://github.com/l3uddz/cloudplow "$HOME"/cloudplow
    cd "$HOME"/cloudplow || exit
    ln -s "$HOME"/cloudplow/cloudplow.py "$HOME"/bin/cloudplow
    source "$HOME"/.bashrc
    exit
    echo "Done."
    exit
else
    echo "Upgrading cloudplow..."
    cd "$HOME"/cloudplow || exit
    git pull
    cd "$HOME" || exit
    echo "Done."
    exit
fi