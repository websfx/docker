export PATH="/usr/local/nginx/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

function get_ip {
    export IP=$(ip addr show eth0 | grep inet | awk '{ print $2; }' | head -1 | cut -d/ -f1)
    PS1="\[\e[0;31m\][\t \[\e[35;39m\]\u\[\e[0;32m\]@$IP \[\e[0;34m\]\w\[\e[0m\]]\\\\$ "
}

# 创建一个新目录并进入
function mkdircd() {
   mkdir -p "$@" && cd "$_";
}

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias dun='du -h  $pwd --max-depth=2 | sort -n'
alias mkdir='mkdir -pv'
alias nano='nano -w'
alias ping='ping -c 5'
alias dmesg='dmesg -HL'
alias vi='vim'

alias lr='ls -R'                    # 递归 ls
alias lz='ll -rS'                   # 按大小排序
alias lt='ll -rt'                   # 按日期排序
alias lh='l | head'
alias lm='la | more'
alias ldot='ls -ld .*'
alias ll='ls -l'
alias l="ls -AFhlt --color"
alias lsd="ls -lF --color | grep --color=never '^d'"
alias cp='cp -i'
alias mv='mv -i'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

PROMPT_COMMAND=get_ip

HISTTIMEFORMAT="%d/%m/%y %T "
