###################
# 設定用関数
###################
function ealias {
    cond=$3
    if [ "x$cond" = "x" ]; then
        $cond=$2
    fi
    which $cond > /dev/null 2>&1
    ret=$?
    if [ $ret -eq 0 ]; then
        alias $1="$2"
    else
        echo "not found command $2"
    fi
}

###################
# 表示設定
###################
autoload -U compinit
compinit 2> /dev/null
autoload -U colors
colors 2> /dev/null
autoload -Uz is-at-least
autoload -Uz vcs_info

fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###################
# キー設定
###################
bindkey -e

###################
# 設定
###################
setopt auto_cd
setopt auto_pushd pushd_ignore_dups
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt multios
setopt brace_ccl
setopt prompt_subst
setopt transient_rprompt
setopt complete_aliases

###################
# ヒストリ
###################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
export WORDCHARS='*?[]~=&;!#$%^(){}<>'

###################
# オートロード
###################
autoload zed
#autoload predict-on
#predict-off

###################
# 検索機能
###################
autoload history-search-end
zle -N history-beginning-search-backword-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
if is-at-least 4.3.10; then
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
else
  bindkey '^R' history-beginning-search-backward-end
  bindkey '^S' history-beginning-search-forward-end
fi

###################
# git completion
###################
autoload bashcompinit
bashcompinit
source ~/repos/github/git/contrib/completion/git-completion.bash

###################
# エイリアス
###################
alias -g G="|grep"
alias -g L="|less"
alias -g LS="|less -S"
alias -g H="|head"
alias -g T="|tail"
alias -g TF="|tail -fn 100"
alias -g TFN="|tail -fn"
alias -g S="|sort"
alias -g W="|wc -l"
alias -g C="LANG=C"

alias where="command -v"
alias j="jobs -l"
alias vi="vim"
alias sc"screen -r"
alias screen="screen -xR"
alias cp="cp -p"
alias la="ls -aF"
alias ll="ls -la"
alias lh="ls -lahF"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias less="less --tabs=4"
alias tailf="tail -f"
alias tailfn="tail -fn"
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'

alias mkctags="ctags -f '.tags' -R"
alias lsctags="ctags --list-maps"
alias rpma="rpm -qal"
alias rpmf="rpm -qf"

alias svi="sudo vi"
alias sless+"sudo less"

alias vizrc="vi ~/.zshrc"
alias vizen="vi ~/.zshenv"
alias srzrc="source ~/.zshrc"
alias srzen="source ~/.zshenv"
alias vivimrc="vi ~/.vimrc"

alias tn="tmux new -s"
alias ta="tmux add -t"
alias tl="tmux ls"

alias cpan-installed="find `perl -e 'print \"@INC\"'` -name '*.pm' -print"
alias cpan-uninstall='perl -MConfig -MExtUtils::Install -e '"'"'($FULLEXT=shift)=~s{-}{/}g;uninstall "$Config{sitearchexp}/auto/$FULLEXT/.packlist",1'"'"
alias cpan-x86="ARCHFLAGS='-arch x86_64 -arch i386 -arch ppc' cpan"

case `uname` in
Darwin)
    alias updatedb="sudo /usr/libexec/locate.updatedb"
    alias mysql5_server="sudo /opt/local/share/mysql5/mysql/mysql.server"
    ;;
Linux)
    ;;
esac

###################
# プロンプト表示
###################
local FGBLK='%{[30m%}' #black
local FGRED='%{[31m%}' #reg
local FGGRN='%{[32m%}' #green
local FGYLW='%{[33m%}' #yelow
local FGBLU='%{[34m%}' #blue
local FGMGN='%{[35m%}' #magenta
local FGCYN='%{[36m%}' #cyan
local FGWHT='%{[37m%}' #white
local BGBLK='%{[40m%}' #black
local BGRED='%{[41m%}' #red
local BGGRN='%{[42m%}' #green
local BGYLW='%{[43m%}' #yelow
local BGBLU='%{[44m%}' #blue
local BGMGN='%{[45m%}' #magenta
local BGCYN='%{[46m%}' #cyan
local BGWHT='%{[47m%}' #white
local DEF='%{[m%}' #reset color
case ${UID} in
0)
    PROMPT="%B%(?.$FGRED.$BGYLW$FGRED)%n$DEF%b %(!.#.$) "
    PROMPT2="%B$FGRED%_>$DEF%b "
    SPROMPT="correct: %R -> %r [nyae]? "
    RPROMPT="%B[$FGGRN%~$DEF]%b"
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        PROMPT="%B$FGCYN${HOST%%.*}$DEF%b ${PROMPT}"
    fi
    ;;
*)
    PROMPT="%(?.$FGRED.$BGYLW$FGRED)%n$DEF %(!.#.$) "
    PROMPT2="$FGRED%_>$DEF "
    SPROMPT="correct: %R -> %r [nyae]? "
    RPROMPT="%1(v|%F{green}%1v%f|)[$FGGRN%~$DEF]"
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        PROMPT="$FGCYN${HOST%%.*}$DEF ${PROMPT}"
    fi
    ;;
esac

####################
# screen
if [ "$TERM" = "screen" ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
        fg)
            if (($#cmd == 1)); then
                cmd=(builtin jobs -l %+)
            else
                cmd=(builtin jobs -l $cmd[2])
            fi
            ;;
        %*)
            cmd=(builtin jobs -l $cmd[1])
            ;;
        cd)
            if (($#cmd == 2)); then
                cmd[1]=$cmd[2]
            fi
            ;&
        *)
            echo -n "k$cmd[1]:t\\"
            return
            ;;
        esac
        local -A jt; jt=(${(kv)jobtexts})
        $cmd >>(read num rest
            cmd=(${(z)${(e):-\$jt$num}})
            echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

####################
# z
. `brew --prefix`/etc/profile.d/z.sh
function precmd () {
    z --add "$(pwd -P)"
}

####################
# git
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting

####################
# python viertualenv for Mac
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/var/pyenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

###################
# functions
function ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

function show_ls_gitstatus() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}

zle -N show_ls_gitstatus
alias l=show_ls_gitstatus
