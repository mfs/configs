# [cmgr] .bash_profile

PATH=$PATH:$HOME/bin

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi

. $HOME/.bashrc

# vim:filetype=sh