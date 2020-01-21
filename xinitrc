# Keyboard settings
xset r rate 300 25
numlockx on

# Replace ugly default cursor
xsetroot -cursor_name left_ptr

# Set wallpaper
~/.fehbg

#. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# Start window manager
exec xmonad
