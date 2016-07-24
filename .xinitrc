# Load X resources
xrdb -merge ~/.Xdefaults

# Load X keyy mappings
[[ -f ~/.xmodmaprc ]] && xmodmap ~/.xmodmaprc

xset r rate 300 25
numlockx on

# Replace ugly default cursor
xsetroot -cursor_name left_ptr

# Execute script to configure monitors
[[ -x ~/bin/xrandr-setup ]] && ~/bin/xrandr-setup

# Set wallpaper
nitrogen --restore

# Start conky instances
for conkyrc in ~/.conkyrc0 ~/.conkyrc1
do
    [[ -f $conkyrc ]] && conky -c $conkyrc
done

# Compositing
#xcompmgr &

#pulseaudio --start

# Disable trackpad while typing
[[ -x /usr/bin/syndaemon ]] && /usr/bin/syndaemon -i 1 -d

# Start window manager
~/bin/wm & pid=$!

# Load ssh keys
#SSH_ASKPASS='/usr/lib/ssh/x11-ssh-askpass' ssh-add < /dev/null

# Wait for wm to exit
wait $pid

# Kill agent
#ssh-agent -k
