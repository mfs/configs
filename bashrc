# [cmgr] .bashrc

# need to prevent .git being searched on removable media

export PATH=/usr/lib/cw:$PATH:$HOME/bin

function exit_status {
    local RED='\033[0;31m' # RED
    local GRE='\033[0;32m' # GREEN

    local es=$1

    if [[ $es == 0 ]];
    then
        printf "${GRE}($es)"
    else
        printf "${RED}($es)"
    fi
}

function hg_ps1 {
    local hgb=$( hg branch 2> /dev/null )
    if [[ $hgb != "" ]]; then
        printf $1 $hgb
    fi
}

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

    local tty=$( tty )
    tty=${tty:5}

    if [ -r /etc/chroot ]; then
        chroot_name="($(cat /etc/chroot))"
    elif [ -r /etc/debian_chroot ]; then
        chroot_name="($(cat /etc/debian_chroot))"
    fi

    if [[ $( type -t __git_ps1 ) == "function" ]]; then
        git_p="\$(__git_ps1 '${LCY}git:%s')"
    fi

    if [[ $( type -t hg ) == "file" ]]; then
        hg_p="\$(hg_ps1 '${LCY}hg:%s')"
    fi

    # need to fix \[ \] around color code for exit status
    PS1="${RED}$chroot_name${LGR}\u${WHI}@${LGR}\h \$(exit_status \$?) "
    PS1="${PS1}${PUR}${tty} ${CYA}\w ${git_p}${hg_p}\n"
    PS1="${PS1}${CYA}>>> ${NOR}"

    PS2="${CYA}... ${NOR}"
}

[ -z "$PS1" ] && return

asm() {

    local ASM_DIR=$( mktemp -d )

    local ASM_SRC=$ASM_DIR/temp.asm
    local ASM_LST=$ASM_DIR/temp.lst
    local ASM_OUT=$ASM_DIR/temp.out

    echo "$1" | sed -e 's/[[:space:]]\{2,\}/\n/g' > $ASM_SRC

    nasm $ASM_SRC -o $ASM_OUT -l $ASM_LST

    [[ $? == 0 ]] && sed -e 's/[[:space:]]*[0-9]*[[:space:]]*//' $ASM_LST

    rm -f $ASM_SRC $ASM_LST $ASM_OUT
    rmdir $ASM_DIR
}

man() {
    local RFC=/usr/share/doc/rfc/txt/$1.txt
    if [ -r $RFC ]
    then
        cat $RFC | sed 's/\f//' | less
    else
        /usr/bin/man $@
    fi
}

pacman() {
    local PMCMD=/usr/bin/pacman

    [[ -x /usr/bin/pacman-color ]] && PMCMD=/usr/bin/pacman-color

    if [[ "$1" =~ ^-S[cuy]|^-S$|^-R|^-U ]]
    then
        sudo $PMCMD $@
    else
        $PMCMD $@
    fi
}

goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

cpf() { cp "$@" && goto "$_"; }

mvf() { mv "$@" && goto "$_"; }

function cd {
    builtin cd "$@"
    [ -n "$DISPLAY" ] && pwd | xsel -s
    if [ "$( pwd )" = $HOME ]
    then
        local COUNT=$( ls -p | grep -v '/' | wc -l )
        if [ $COUNT -gt 0 ]
        then
            echo "$(tput setaf 1)### $COUNT FILES IN ~ ###$(tput sgr0)"
        fi
    fi
}

function uml {
    [ -e README ] || return
    [[ $( head -n 1 README ) =~ Linux\ kernel\ release\ 2.6.xx ]] || return
    make mrproper
    make mrproper ARCH=um
    make defconfig ARCH=um
    make -j 3 ARCH=um
    cp linux $HOME/bin/linux-$( ./linux --version )
    make modules_install INSTALL_MOD_PATH=$HOME/bin/uml_modules ARCH=um
}

function color {
    if [[ $1 =~ ([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2}) ]]
    then
        printf "(%d, %d, %d)\n" \
               0x${BASH_REMATCH[1]} 0x${BASH_REMATCH[2]} 0x${BASH_REMATCH[3]}
    elif [[ $1 =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]
    then
        printf "#%02x%02x%02x\n" \
               ${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}
    fi
}

function bm {
    if [ -e .bookmarks ]
    then
        for URL in $(cat .bookmarks )
        do
            chromium $URL
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

export GOROOT="$HOME/code/go"
export GOARCH="amd64"
export GOOS="linux"
export GOBIN="$HOME/bin"

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
    [[ -r ~/.dircolors ]] && eval "`dircolors -b ~/.dircolors`"
    alias jj='javac *.java'
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias aurploader='aurploader -r'
    alias vk='grep "map <F[0-9]\{1,2\}>" ~/.vimrc'
    alias grep='grep --color=auto'
    alias diff='colordiff'
    alias pacs='pacsearch'
    alias ss='sudo shutdown -h now'
    alias pizza='echo "PIZZA READY IN:"; utimer -c 15m'
    alias ssh='TERM=xterm ssh'
    alias dp='pwd | xsel -s'
    alias pd='cd "$( xsel -so )"'
    alias quakelive='LD_PRELOAD=/usr/lib/libpng12.so
                     /usr/bin/firefox http://www.quakelive.com'
fi

#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi


