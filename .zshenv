###################
# 基本
###################
export LANG=ja_JP.UTF-8
#export LANG=ja_JP.eucJP

export BLOCKSIZE=M
export EDITOR=vi
export PAGER=less
export MANPEGER=less

export LESS='-R'
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'


export VIMHOME=$HOME/.vim
export RSYNC_RSH=ssh
#compdef mosh=ssh

###################
# プログラム環境
###################
# CVS
#export CVS_ROOT=
export CVS_RSH=ssh
export CVS_SSH=ssh
export CVSEDITOR=vim
# SVN
#export SVN_ROOT=
export SVN_SSH=ssh
export SVN_EDITOR=vim


case `uname` in
Darwin)
###################
# Mac
###################
    # HomeBrew
    export BREWHOME=/usr/local
    export PYTHONPATH=
    export PYTHONPATH=$BREWHOME/Cellar/python/2.7.2/lib/python2.7/site-packages:$PYTHONPATH
    export PYTHONPATH=$BREWHOME/Cellar/python/2.7.3/lib/python2.7/site-packages:$PYTHONPATH

    # Xcode
    export IP_XCODE=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator3.1.2.sdk/System/Library/Frameworks
    export MAC_XCODE=/Developer/SDKs/MacOSX10.4u.sdk/System/Library/Frameworks

    # Perl
    [[ -s $HOME/perl5/perlbrew/etc/bashrc ]] && source $HOME/perl5/perlbrew/etc/bashrc
    # Python
    [[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc
    [[ -f /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
    [[ -s `which virtualenvwrapper.sh` ]] && source `which virtualenvwrapper.sh`
    # Ruby
    export rvm_path=/usr/local/rvm
    [[ -e /usr/local/lib/rvm ]] && source /usr/local/lib/rvm

    # Go lang
    if [ -x `which go` ]; then
        export GOROOT=`go env GOROOT`
        export GOPATH=$HOME/code/go-local
        export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    fi

    ;;
Linux)
###################
# Linux
###################
    # Perl
    export PERL_BADLANG=0
    # C and C plus
    export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/:/usr/local/lib/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/lib/:/usr/local/lib/
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:.:/usr/include/:/usr/local/include/
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:.:/usr/include/:/usr/local/include/
    # Java
    export JAVA_HOME=/usr/lib/jvm/java-6-sun
    export CLASSPATH=$CLASSPATH:.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar:/usr/share/java/jsp-api.jar:/usr/share/java/servlet-api.jar
    export MANPATH=$MANPATH:$JAVA_HOME/man
    export CATALINA_HOME=/usr/share/tomcat5.5
    export PATH=$PATH:$JAVA_HOME/bin
    # Perl
    export PERL5LIB=$PERL5LIB:/usr/lib/perl5/5.10.1
    # Ruby
    ;;
esac


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
    zstyle ':completion:*' list-colors \
        'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
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
