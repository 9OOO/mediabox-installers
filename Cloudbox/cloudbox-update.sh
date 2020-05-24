#!/bin/sh

# Personal Full Cloudbox Upgrade Script
# I usually cron this every month

if [ -z "$STY" ]; then exec screen -dm -S cloudbox-update /bin/bash "$0"; fi
    cd "$HOME"/cloudbox || exit
    git fetch
    git reset --hard @{u}
    sudo ansible-playbook cloudbox.yml --tags cloudbox,community,emby,bazarr,sabnzbd,plex_dupefinder
    cd "$HOME"/community || exit
    git fetch
    git checkout develop
    git reset --hard @{u}
    sudo ansible-playbook community.yml --tags speedtest,sshwifty,kitana,vnstat,asshama,epms,nextcloud,requestrr,alltube
    sudo ansible-playbook community.yml --tags speedtest,sshwifty,kitana,vnstat,asshama,epms,nextcloud,requestrr,alltube
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/Sub-Zero.bundle/
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/Trakttv.bundle/
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/WebTools.bundle/
    sudo "$HOME"/scripts/iptables.sh
    sudo reboot