#!/bin/sh

# Personal Full Cloudbox Upgrade Script
# I usually cron this every month

if [ -z "$STY" ]; then exec screen -dm -S cloudbox-update /bin/bash "$0"; fi
    cd "$HOME"/cloudbox || exit
    sudo ansible-playbook cloudbox.yml --tags backup
    git fetch
    git reset --hard @{u}
    sudo ansible-playbook cloudbox.yml --tags cloudbox,community,emby,bazarr,plex_dupefinder
    cd "$HOME"/community || exit
    git fetch
    git checkout develop
    git reset --hard @{u}
    sudo ansible-playbook community.yml --tags speedtest,sshwifty,kitana,vnstat,asshama,epms,nextcloud,requestrr
    sudo ansible-playbook community.yml --tags speedtest,sshwifty,kitana,vnstat,asshama,epms,nextcloud,requestrr
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/Sub-Zero.bundle/
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/Trakttv.bundle/
    sudo rm -rfv /opt/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/WebTools.bundle/
    sudo /home/xan/scripts/iptables.sh
    sudo reboot