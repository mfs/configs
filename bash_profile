# [cmgr] .bash_profile

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi

. $HOME/.bashrc

# vim:filetype=sh
