#!/bin/sh

# Rclone Torrents Migrator from USB Deluge to Hetz rTorrent by Xan#7777
# I usually cron this every month on USB Box

# Variables
ip=xyz.xyz.xyz.xyz
port=zzzzz
username=yyyyyyy
password=xxxxxxx

if [ -z "$STY" ]; then exec screen -dm -S rclone-migrate /bin/bash "$0"; fi
    eval $(ssh-agent -s)
    ssh-add "$HOME"/.ssh/dedi
    rclone copy "$HOME"/Downloads/ dedi:/mnt/local/downloads/torrents/rutorrent/completed/ -vP --fast-list
    rclone copy "$HOME"/.config/deluge/state/ dedi:/mnt/local/downloads/torrents/rutorrent/watched/ --include *.{torrent} -vP --fast-list
    for id in `deluge-console "connect '$ip':'$port' '$username' '$password'; info" | grep "^ID: " | sed -En "s/ID: //p"`; do deluge-console "connect '$ip':'$port' '$username' '$password'; rm $id --remove_data"; done
exit