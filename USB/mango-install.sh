#!/bin/sh

# Mango Installer by Xan#7777

printf "\033[0;31mDisclaimer: Don't blame me if this nuked your setup or something...\033[0m\n"
read -r -p "Type confirm if you wish to continue: " input
if [ ! "$input" = "confirm" ]
then
    exit
fi

# Download Mango
clear
curl -s https://api.github.com/repos/hkalexling/Mango/releases/latest | grep -oP '"browser_download_url": "\K(.*)(?=")' | wget -i - -O "$HOME"/bin/mango
chmod +x "$HOME"/bin/mango
chown "$USER":"$USER" "$HOME"/bin/mango

# Generate Config file
clear
echo "Testing Mango Install. Enter y to generate config."
echo "Get generated credentials shown here to login to your mango instance for the first time."
echo "CTRL + C when you get the credentials and do not forget to change it afterwards."
echo ""
sleep 1
"$HOME"/bin/mango
wait

# Unused Port Picker
clear
app-ports show

echo ""
echo "Pick any application from this list that you're not currently using."
echo "We'll be using this port for The Lounge."
echo "For example, you chose SickRage so type in 'sickrage'. Please type it in full name."
echo "Type in the application below."
read -r appname

proper_app_name=$(app-ports show | grep -i "$appname" | cut -c 7-)
port=$(app-ports show | grep -i "$appname" | cut -b -5)

echo ""
echo "Are you sure you want to use $proper_app_name's port? type 'confirm' to proceed."
read -r input

if [ ! "$input" = "confirm" ]
then
    exit 0
fi

# Set NGINX conf
clear 
echo "Please wait..."
app-nginx uninstall
app-nginx install
echo 'location /mango/ {
    proxy_pass http://localhost:<port>/;
}' > "$HOME/.apps/nginx/proxy.d/mango.conf"
sed  -i "s|<port>|$port|g" "$HOME"/.apps/nginx/proxy.d/mango.conf

# Set systemd service
echo "[Unit]
Description=Mango manga server
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=$HOME/bin/mango

[Install]
WantedBy=default.target" > "$HOME/.config/systemd/user/mango.service"

# Sed Config
sed  -i "s|port: 9000|port: $port|g" "$HOME"/.config/mango/config.yml
sed  -i "s|base_url: \/|base_url: \/mango|g" "$HOME"/.config/mango/config.yml
sed  -i "s|library_path: $HOME\/mango\/library|library_path: $HOME\/MergerFS\/Media\/Comics\/Manga|g" "$HOME"/.config/mango/config.yml

# Starting services and exit
app-nginx restart
systemctl --user daemon-reload
systemctl --user enable --now mango.service
clear
echo "Installation complete."
echo "You can access it via https://$USER.$HOSTNAME.usbx.me/mango"
rm -- "$0"
exit