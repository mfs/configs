
# Load X resources
xrdb -merge .Xdefaults

# Load X keyy mappings
xmodmap .xmodmap

xset r rate 300 25

# Load fonts
xset +fp /usr/local/share/fonts/artwiz-fonts
xset +fp /usr/local/share/fonts/proggy
xset +fp /usr/local/share/fonts/profont-x11
xset +fp /usr/local/share/fonts/corel
xset +fp /usr/local/share/fonts/codec

# Replace ugly default cursor
xsetroot -cursor_name left_ptr

# Set wallpaper
nitrogen --restore

# Compositing
xcompmgr &

# Start ssh-agent
eval `ssh-agent`

# Start window manager
/home/mike/bin/xmonad & pid=$!

# Load ssh keys
SSH_ASKPASS='/usr/lib/openssh/x11-ssh-askpass' ssh-add < /dev/null

# Start status bars
/home/mike/bin/status-bars.py &

wait $pid

# Kill agent
ssh-agent -k
