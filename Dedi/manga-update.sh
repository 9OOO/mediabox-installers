#!/bin/bash

#variables
mapfile -t mangadex < /home/xan/md-dl/mdl.txt
mapfile -t mangahere < /home/xan/md-dl/mcc.txt
mdl=/home/xan/.local/bin/manga-py
output=/mnt/local/Media/Comics/Manga

if [ -z "$STY" ]; then exec screen -dm -S manga-dl-sync /bin/bash "$0"; fi
    for i in "${mangadex[@]}"
    do
        "$mdl" "$i" -d "$output" -z -R -u 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36' --arguments language=gb
    done
        for i in "${mangahere[@]}"
    do
        "$mdl" "$i" -d "$output" -z -R -u 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36'
    done
    /usr/local/bin/cloudplow upload