# [cmgr] .bash_profile

. $HOME/.bashrc

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi

# vim:filetype=sh
