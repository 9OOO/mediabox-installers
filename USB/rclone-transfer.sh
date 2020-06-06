#!/bin/sh

# Rclone Torrents Migrator from USB Deluge to Hetz rTorrent by Xan#7777
# Just put this in a systemd service/systemd timer every 30 minutes or so

# Variables
ip=xyz.xyz.xyz.xyz
port=zzzzz
username=yyyyyyy
password=xxxxxxx
home=$(quota -s | grep '/' | awk {'print $1'})
quota=$(quota -s | grep "$home" | awk {'print $3'})
max=1000G
usb

if [ "$quota" -ge "$max" ]; then exec screen -dm -S rclone-migrate /bin/bash "$0"; fi; exit
    rsync -aHAxv --numeric-ids --delete -P -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x" "$HOME"/Downloads/. dedi:/mnt/local/downloads/torrents/rutorrent/completed/.
    rsync -aHAxv --numeric-ids --delete -P --include='*.torrent' -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x" "$HOME"/.config/deluge/state/. dedi:/mnt/local/downloads/torrents/rutorrent/watched/.
    for id in $(deluge-console "connect '$ip':'$port' '$username' '$password'; info" | grep "^ID: " | sed -En "s/ID: //p"); do deluge-console "connect '$ip':'$port' '$username' '$password'; rm $id --remove_data"; done