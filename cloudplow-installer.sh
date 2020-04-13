#!/bin/bash

# Cloudplow Installer/Updater Script by Xan#7777

# Run the following command before running this
# curl https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/deluge-rtorrent/pip-install.sh | bash && exit


if [ ! -d "$HOME/cloudplow" ];
then
    echo "Installing cloudplow..."
    git clone https://github.com/l3uddz/cloudplow "$HOME"/cloudplow
    cd "$HOME"/cloudplow || exit
    pip3 install --user -r requirements.txt --upgrade
    ln -s "$HOME"/cloudplow/cloudplow.py "$HOME"/bin/cloudplow
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