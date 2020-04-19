#!/bin/bash

# Rclone VFS/MergerFS Installer/Updater Script by Xan#7777
# Tested on USB. Your provider setup may vary.

echo "Creating necessary folders..."
    mkdir -p "$HOME"/Stuff
    mkdir -p "$HOME"/Stuff/Local
    mkdir -p "$HOME"/Stuff/Mount
    mkdir -p "$HOME"/MergerFS
    mkdir -p "$HOME"/.config/systemd/user
    mkdir -p "$HOME"/.rclone-tmp
    mkdir -p "$HOME"/.mergerfs-tmp

echo "Stopping service files..."
    systemctl --user disable --now mergerfs.service
    systemctl --user disable --now rclone-vfs.service
    systemctl --user disable --now rclone-normal.service

echo "Killing all rclone/mergerfs instances..."
    killall rclone
    killall mergerfs

echo "Removing service files and old binaries for upgrade..."
    cd "$HOME"/.config/systemd/user
    rm rclone*
    rm mergerfs*
    cd "$HOME"/bin
    rm rclone
    rm mergerfs
    cd "$HOME"/scripts
    rm rclone*
    rm -rfv "$HOME"/.rclone-tmp/*
    rm -rfv "$HOME"/.mergerfs-tmp/*

echo "Installing rclone..."
    cd "$HOME"/.rclone-tmp || exit
    wget https://downloads.rclone.org/v1.50.2/rclone-v1.50.2-linux-amd64.zip -O "$HOME"/.rclone-tmp/rclone.zip
    unzip rclone.zip
    cp "$HOME"/.rclone-tmp/rclone-v*/rclone "$HOME"/bin
    command -v rclone
    rclone version
echo ""

echo "Done. Installing mergerfs..."
    cd "$HOME"/.mergerfs-tmp || exit
    wget https://github.com/trapexit/mergerfs/releases/download/2.28.3/mergerfs_2.28.3.debian-stretch_amd64.deb -O "$HOME"/.mergerfs-tmp/mergerfs.deb
    dpkg -x "$HOME"/.mergerfs-tmp/mergerfs.deb "$HOME"/.mergerfs-tmp
    mv "$HOME"/.mergerfs-tmp/usr/bin/* "$HOME"/bin
    command -v mergerfs
    mergerfs -v
echo ""

echo "Set up your rclone config..."
echo "rclone config will be executed."
echo "Please setup your remotes before continuing."
echo "Also take note of your remote name..."
    sleep 3
    rclone config
    wait
echo ""

echo "Name of remote? Type below and press Enter."
    read -r remotename
    sleep 2
    echo ""
    echo ""
    echo "Your remote name is $remotename."
    echo "This will be appended to your rclone mount service files..."
    echo ""

echo "Done. Downloading service files..."
    sleep 2
    cd "$HOME"/.config/systemd/user || exit
    wget https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/MergerFS-Rclone/Service%20Files/rclone-vfs.service
    wget https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/MergerFS-Rclone/Service%20Files/mergerfs.service
    sed -i "s#/homexx/yyyyy#$HOME#g" "$HOME"/.config/systemd/user/rclone-vfs.service
    sed -i "s#gdrive:#$remotename:#g" "$HOME"/.config/systemd/user/rclone-vfs.service
    sed -i "s#/homexx/yyyyy#$HOME#g" "$HOME"/.config/systemd/user/mergerfs.service

# Upload Script Download
    echo "Installing upload script..."
    wget https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/MergerFS-Rclone/Upload%20Scripts/rclone-uploader.service
    wget https://raw.githubusercontent.com/ultraseedbox/UltraSeedbox-Scripts/master/MergerFS-Rclone/Upload%20Scripts/rclone-uploader.timer
    sed -i "s#/homexx/yyyyy#$HOME#g" "$HOME"/.config/systemd/user/rclone-uploader.service
    sed -i "s#gdrive:#$remotename:#g" "$HOME"/.config/systemd/user/rclone-uploader.service

echo "Starting services..."
    systemctl --user daemon-reload
    systemctl --user enable --now rclone-vfs.service
    systemctl --user enable --now mergerfs.service
    systemctl --user enable --now rclone-uploader.service
    systemctl --user enable --now rclone-uploader.timer

echo "Script cleanup..."
    rm -rfv "$HOME"/.rclone-tmp
    rm -rfv "$HOME"/.mergerfs-tmp

echo ""
sleep 5
echo ""
echo "Done."
cd "$HOME" || exit
exit