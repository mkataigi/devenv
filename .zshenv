###################
# 基本
###################
export LANG=ja_JP.UTF-8

export BLOCKSIZE=M
export EDITOR=vi
export PAGER=less
export MANPEGER=less
export RSYNC_RSH=ssh

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
eval $(/opt/homebrew/bin/brew shellenv)

export LESS='-R'
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

export VIMHOME=$HOME/.vim

###################
# プログラム環境
###################
# CVS
export CVS_RSH=ssh
export CVS_SSH=ssh
export CVSEDITOR=vim
# SVN
export SVN_SSH=ssh
export SVN_EDITOR=vim

###################
# Env Common
###################
# C and C plus
export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/:/usr/local/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/lib/:/usr/local/lib/
export C_INCLUDE_PATH=$C_INCLUDE_PATH:.:/usr/include/:/usr/local/include/
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:.:/usr/include/:/usr/local/include/

# Java
export JAVA_HOME=
export CLASSPATH=$CLASSPATH:.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar:/usr/share/java/jsp-api.jar:/usr/share/java/servlet-api.jar
#export MANPATH=$MANPATH:$JAVA_HOME/man
#export PATH=$PATH:$JAVA_HOME/bin

# Perl
export PERL5LIB=$PERL5LIB:/usr/lib/perl5/5.10.1
if [ -s $HOME/perl5/perlbrew/etc/bashrc ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

# Python
export PYENV_ROOT=$HOME/.pyenv
if [[ -n `which pyenv` ]]; then
    export PATH=$PYENV_ROOT/shims:$PATH
    eval "$(pyenv init -)"
fi
if [[ -n `which pyenv-virtualenv-init` ]]; then
    eval "$(pyenv virtualenv-init -)";
fi

# Ruby
export rvm_path=/usr/local/rvm
[[ -e /usr/local/lib/rvm ]] && source /usr/local/lib/rvm
if [[ -d ~/.rbenv  ]]; then
    export PATH=${HOME}/.rbenv/bin:${PATH}
    eval "$(/usr/local/bin/rbenv init -)"
fi

# Go lang
export GOPATH=$HOME/code/go-local
if [[ -x `which go` ]]; then
    export GOROOT=`go env GOROOT`
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# Node.js
export NVM_DIR="$HOME/.nvm"
if [ -s $(brew --prefix nvm)/nvm.sh ]; then
    source $(brew --prefix nvm)/nvm.sh
fi

# direnv
eval "$(direnv hook zsh)"

case `uname` in
###################
# Env Mac
###################
Darwin)
    # HomeBrew
    export BREWHOME=/usr/local

    # Shell
    if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    # Xcode
    export IP_XCODE=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator3.1.2.sdk/System/Library/Frameworks
    export MAC_XCODE=/Developer/SDKs/MacOSX10.4u.sdk/System/Library/Frameworks

    ;;
###################
# Env Linux
###################
Linux)
    # Perl
    export PERL_BADLANG=0

    ;;
esac

#######################
# Other Environment
#######################
### Added by the Heroku Toolbelt
if [ -d '/usr/local/heroku/bin' ]; then export PATH="/usr/local/heroku/bin:$PATH"; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mkataigi/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/mkataigi/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/mkataigi/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/mkataigi/google-cloud-sdk/completion.zsh.inc'; fi

##########################
# terminal configuration
##########################
unset LSCOLORS
case "${TERM}" in
xterm)
    export TERM=xterm-color
    ;;
kterm)
    export TERM=kterm-color
    # set BackSpace control character
    stty erase 
    ;;
screen)
    ;;
cons25)
    export TERM=xterm-color
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors \
        'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
screen)
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg)
                if (( $#cmd == 1 )); then
                    cmd=(builtin jobs -l %+)
                else
                    cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
            %*)
                cmd=(builtin jobs -l $cmd[1])
                ;;
            cd)
                if (( $#cmd == 2)); then
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
    ;;
esac

for config in `ls $HOME/.zshenv.* 2> /dev/null`; do
    source $config
done

echo $PYENV_ROOT
