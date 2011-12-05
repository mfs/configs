# [cmgr] .xinitrc

# Load X resources
xrdb -merge .Xdefaults

# Load X keyy mappings
xmodmap $HOME/.xmodmap

xset r rate 300 25

# Load fonts
xset +fp /usr/local/share/fonts/artwiz-fonts
xset +fp /usr/local/share/fonts/proggy
xset +fp /usr/local/share/fonts/profont-x11
xset +fp /usr/local/share/fonts/corel
xset +fp /usr/local/share/fonts/codec

# Replace ugly default cursor
xsetroot -cursor_name left_ptr

# If two monitors are present, setup tiling.
if [[ -x /usr/bin/xrandr ]]; then
    OUTPUTS=($( xrandr | grep ' connected ' | cut -f 1 -d ' '))
    if [[ ${#OUTPUTS[@]} == 2 ]]; then
        xrandr --output ${OUTPUTS[0]} --left-of ${OUTPUTS[1]}
    fi
fi

# Set wallpaper
nitrogen --restore

# Compositing
xcompmgr &

# Start ssh-agent
eval `ssh-agent`

# Start window manager
/home/mike/code/dwm/dwm & pid=$!

# Load ssh keys
SSH_ASKPASS='/usr/lib/ssh/x11-ssh-askpass' ssh-add < /dev/null

# Start status bars
/home/mike/code/py-dwm-status/py-dwm-status.py -X &

wait $pid

# Kill agent
ssh-agent -k
