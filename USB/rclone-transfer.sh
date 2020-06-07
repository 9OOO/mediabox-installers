#!/bin/sh

# Rclone Torrents Migrator from USB Deluge to Hetz rTorrent by Xan#7777
# Relies on quota and deluge-console

# It rsyncs files and torrents to rutorrent on my dedi
# Then sends deluge-console commands to delete all torrents/data
# Just put this in cron every 10 minutes or so

# Variables
ip=xyz.xyz.xyz.xyz # Deluge IP
port=zzzzz # Deluge Daemon Port
username=yyyyyyy # Deluge Username
password=xxxxxxx # Deluge Passowrd
quota=$(quota -s | grep "/" | awk {'print $2'} | sed 's/.$//') # Gets set quota
max=1000 # enter your set threshold here EG. 1000 or 550. Run quota -s to get quota measurement (M, G, T)

if [ "$quota" -ge "$max" ] && [ -z "$STY" ]; then exec screen -dm -S rclone-migrate /bin/bash "$0"; fi; exit
    rsync -aHAxv --numeric-ids --delete -P -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x" "$HOME"/Downloads/. dedi:/mnt/local/downloads/torrents/rutorrent/completed/.
    rsync -aHAxv --numeric-ids --delete -P --include='*.torrent' -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x" "$HOME"/.config/deluge/state/. dedi:/mnt/local/downloads/torrents/rutorrent/watched/.
    for id in $(deluge-console "connect '$ip':'$port' '$username' '$password'; info" | grep "^ID: " | sed -En "s/ID: //p"); do deluge-console "connect '$ip':'$port' '$username' '$password'; rm $id --remove_data"; done
    exit