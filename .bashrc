# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PROMPT_DIRTRIM=1
export BROWSER=chromium
export EDITOR=vim
export HISTCONTROL=ignoredups
export SCONSFLAGS="-Q -j 3"

shopt -s checkwinsize

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.cargo/bin:$PATH"

eval $(dircolors ~/.dircolors)
alias ssh='TERM=xterm-256color ssh'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias dt='dmesg | tail'
alias grep='grep --color=auto'
alias diff='colordiff'
alias iso8601='date --iso-8601=seconds'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# ssh-agent - http://rabexc.org/posts/pitfalls-of-ssh-agents
ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add
  fi
fi

# trying liquid prompt
source ~/liquidprompt/liquidprompt

# clear $? for prompt
/usr/bin/true
