#!/bin/sh
if [ -z "$STY" ]; then exec screen -dm -S cloudbox-update /bin/bash "$0"; fi
    cd $HOME/cloudbox || exit
    git fetch
    git reset --hard @{u}
    sudo ansible-playbook cloudbox.yml --tags cloudbox,community,emby,bazarr
    cd $HOME/community || exit
    git fetch
    git reset --hard @{u}
    sudo ansible-playbook community.yml --tags jellyfin,speedtest,thelounge,sshwifty,kitana,deezloader-remix,vnstat,asshama,epms,nextcloud
    sudo ansible-playbook community.yml --tags jellyfin,speedtest,thelounge,sshwifty,kitana,deezloader-remix,vnstat,asshama,epms,nextcloud
    docker exec thelounge thelounge upgrade
    sudo reboot