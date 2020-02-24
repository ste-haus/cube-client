#!/bin/bash

DIR=`pwd`
USER=cube
PASSWORD=`openssl rand -hex 8`
RESOLUTION=1400x900

## check permissions
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

## install scripts
mkdir -p $DIR
mv * $DIR

## install service
echo "installing control server..."
ln -s $DIR/service/cube-control-server.service /etc/systemd/system/cube-control-server.service
systemctl daemon-reload
systemctl enable cube-control-server.service
service cube start

## install network monitor
echo "installing network monitor..."
ln -s $DIR/service/cube-network-monitor.service /etc/systemd/system/network-monitor.service
systemctl daemon-reload
systemctl enable network-monitor.service
service cube start

## create user
echo "creating '$USER' user..."
su -c "useradd $USER -s /bin/bash -m"
echo "$USER:$PASSWORD" | chpasswd

## allow user to restart
echo "granting user permissions..."
echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/reboot" >> /etc/sudoers

## set sleep settings
echo "disabling sleep..."
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type "'nothing'"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"
dconf write /org/gnome/settings-daemon/plugins/power/idle-dim false
dconf write /org/gnome/desktop/session/idle-delay "uint32 180"

## disable lock screen
echo "disabling lock screen..."
gsettings set org.gnome.desktop.screensaver lock-enabled fase

## disable lock shield
echo "disabling lock shield..."
apt install -f git gnome-tweaks
git clone https://github.com/lgpasquale/gnome-shell-extension-disable-screenshield.git /home/$USER/.local/share/gnome-shell/extensions/disable-screenshield@lgpasquale.com
sudo -u $USER dconf write /org/gnome/shell/enabled-extensions "['disable-screenshield@lgpasquale.com']"

## set resolution
echo "setting screen resolution to $RESOLUTION..."
sudo -u $USER export DISPLAY=:0.0 && xrandr --size $RESOLUTION

## disable bluetooth
systemctl disable bluetooth.service

## fix wifi powersave bug
echo "fixing sp3 wifi powersave bug..."
sed -i "s/wifi.powersave.*/wifi.powersave = 2/g" /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

## install chrome
echo "installing chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
apt update
apt install -f google-chrome-stable

## auto login
echo "enabling auto-login..."
sed -i "s/# AutomaticLoginEnable.*/AutomaticLoginEnable=True/g" /etc/gdm5/custom.conf
sed -i "s/# AutomaticLogin.*/AutomaticLogin=$USER/g" /etc/gdm5/custom.conf

## start at login
echo "enabling auto-start..."
mkdir -p /home/$USER/.config/autostart/
ln -s $DIR/conf/cube.desktop /home/$USER/.config/autostart/cube.desktop

## enable motion detection
apt install -f motion
sed -i "s/start_motion_daemon=.*/start_motion_daemon=yes/g" /etc/default/motion
mv /etc/motion/motion.conf /etc/motion/motion.conf
ln -s $DIR/conf/cube.motion /etc/motion/motion.conf

