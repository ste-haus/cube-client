1) install ubuntu
2) create cube user
3) ssh cert for cube user
4) set sleep settings
5) disable sleep settings
6) disable lock screen
7) install gnome tweaks
8) grub timeout to 5 seconds
9) install cube service
  - ln -s /data/cube.service /etc/systemd/system/cube.service
  - systemctl daemon-reload
  - systemctl enable cube.service
  - service cube start
10) all cube user to reboot
11) Autostart cube
  - mkdir -p /home/cube/.config/autostart/
  - ln -s /data/cube.desktop /home/cube/.config/autostart/

### gnome tweaks
apt install gnome-tweaks
https://github.com/lgpasquale/gnome-shell-extension-disable-screenshield
Tweak Tool → Extension → Disable Screen Lock → On

### sleep screen
xset -display :0 dpms force $1

### wake screen
https://askubuntu.com/questions/358934/sending-keypresses-to-remote-x-session-over-ssh
`DISPLAY=:0 xdotool mousemove 10 10 && DISPLAY=:0 xdotool mousemove 0 0 && DISPLAY=:0 xdotool click 1`

apt install motion
mkdir -p /home/$USER/.motion
ln -s /data/cube.motion /home/$USER/.motion/motion.conf

