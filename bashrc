# [cmgr] .bashrc

# need to prevent .git being searched on removable media

export PATH=$PATH:/home/mike/bin

function set_prompt {
    local BLA='\[\033[0;30m\]' # BLACK
    local DGR='\[\033[1;30m\]' # DGRAY
    local RED='\[\033[0;31m\]' # RED
    local LRE='\[\033[1;31m\]' # LRED
    local GRE='\[\033[0;32m\]' # GREEN
    local LGR='\[\033[1;32m\]' # LGREEN
    local BRO='\[\033[0;33m\]' # BROWN
    local YEL='\[\033[1;33m\]' # YELLOW
    local BLU='\[\033[0;34m\]' # BLUE
    local LBL='\[\033[1;34m\]' # LBLUE
    local PUR='\[\033[0;35m\]' # PURPLE
    local LPU='\[\033[1;35m\]' # LPURPLE
    local CYA='\[\033[0;36m\]' # CYAN
    local LCY='\[\033[1;36m\]' # LCYAN
    local LGY='\[\033[0;37m\]' # LGRAY
    local WHI='\[\033[1;37m\]' # WHITE
    local NOR='\[\033[0m\]'    # NORMAL

    if [ -r /etc/chroot ]; then
        chroot_name=$(cat /etc/chroot)
    fi

    case $UID in
    0)
        PS1="${LRE}[${LGR}\H${LRE}|${CYA}\w${LRE}] \\$ ${NOR}"
        ;;
    *)
        PS1="${RED}$chroot_name${WHI}[${LGR}\u${WHI}@${LGR}\H${WHI}|${CYA}\w\$(__git_ps1 '${WHI}|${LCY}%s')${WHI}] \\$ ${NOR}"
        ;;
    esac
}

[ -z "$PS1" ] && return

function color {
    if [[ $1 =~ ([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2}) ]]
    then
        printf "(%d, %d, %d)\n" \
               0x${BASH_REMATCH[1]} 0x${BASH_REMATCH[2]} 0x${BASH_REMATCH[3]}
    elif [[ $1 =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]
    then
        printf "#%02x%02x%02x\n" ${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}
    fi
}

function bm {
    if [ -e .bookmarks ]
    then
        for URL in $(cat .bookmarks )
        do
            firefox $URL
        done
    fi
}

function aur {
    if (( $# != 1 ))
    then
        echo "usage: aur <package>"
        return
    fi

    local PKGDIR=$HOME/pkgs
    local FILENAME=$1.tar.gz

    cd $PKGDIR && rm -f $FILENAME

    echo -n "Downloading $FILENAME ... "

    wget -q http://aur.archlinux.org/packages/$1/$FILENAME

    if (( $? ))
    then
        echo "[FAIL]"
        return
    fi

    echo "[DONE]"

    tar xzf $FILENAME
    cd $1
    ls -lh
}

function tputcolors {
    local txtund=$(tput sgr 0 1)          # Underline
    local txtbld=$(tput bold)             # Bold
    local bldred=${txtbld}$(tput setaf 1) #  red
    local bldblu=${txtbld}$(tput setaf 4) #  blue
    local bldwht=${txtbld}$(tput setaf 7) #  white
    local txtrst=$(tput sgr0)             # Reset
    local info=${bldwht}*${txtrst}        # Feedback
    local pass=${bldblu}*${txtrst}
    local warn=${bldred}!${txtrst}

    echo
    echo -e "$(tput bold) reg  bld  und   tput-command$(tput sgr0)"

    for i in $(seq 1 7); do
        echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
    done

    echo ' Bold            $(tput bold)'
    echo ' Underline       $(tput sgr 0 1)'
    echo ' Reset           $(tput sgr0)'
    echo

}

export GOROOT="/home/mike/code/go"
export GOARCH="amd64"
export GOOS="linux"
export GOBIN="/home/mike/bin"

export EDITOR=vim
export HISTCONTROL=ignoredups
export SCONSFLAGS="-Q -j 3"

shopt -s checkwinsize

set_prompt

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b ~/.dircolors`"
    alias pacman='pacman-color'
    alias spacman='sudo pacman-color'
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias diff='colordiff'
    alias pacs='pacsearch'
    alias ss='sudo shutdown -h now'
    alias pizza='echo "PIZZA READY IN:"; utimer -c 15m'
    alias ssh='TERM=xterm ssh'
    alias pud='pwd | xsel -s'
    alias pod='cd "$( xsel -so )"'
fi

#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi


