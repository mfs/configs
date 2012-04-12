# [cmgr] .xinitrc

# Load X resources
xrdb -merge ~/.Xdefaults

# Load X keyy mappings
[[ -f ~/.xmodmap ]] && xmodmap ~/.xmodmap

xset r rate 300 25

# Load fonts
xset +fp /usr/local/share/fonts/artwiz-fonts
xset +fp /usr/local/share/fonts/proggy
xset +fp /usr/local/share/fonts/profont-x11
xset +fp /usr/local/share/fonts/corel
xset +fp /usr/local/share/fonts/codec

# Replace ugly default cursor
xsetroot -cursor_name left_ptr

# Execure script to configure monitors
[[ -x ~/bin/xrandr-setup ]] && ~/bin/xrandr-setup

# Set wallpaper
nitrogen --restore

# Compositing
xcompmgr &

# Disable trackpad while typing
[[ -x /usr/bin/syndaemon ]] && /usr/bin/syndaemon -i 1 -d

# Start ssh-agent
eval `ssh-agent`

# Start window manager
~/bin/wm & pid=$!

# Load ssh keys
SSH_ASKPASS='/usr/lib/ssh/x11-ssh-askpass' ssh-add < /dev/null

# Start status bars
~/code/py-dwm-status/py-dwm-status.py -X &

wait $pid

# Kill agent
ssh-agent -k
