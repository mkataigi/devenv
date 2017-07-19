# ~/.bashrc
#############################

# 基本設定
# 言語
export LANG=ja_JP.UTF-8
# 履歴
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
# ファイル属性
umask 022
export BLOCKSIZE=M
# Ctrl-D でログアウトするのを抑制する。
IGNOREEOF=3
# プロンプト
# \u  : ユーザ名
# \h  : マシン名
# \W  : カレントディレクトリ
# \\$ : スーパーユーザは「#」一般ユーザは「$」で表示
if [ "$color_prompt" = yes ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;3m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi
# 画面サイズを変更すると COLUMNS, LINES を変更する。
if [ "$DISPLAY" ]; then
  shopt -s checkwinsize
fi
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Mac
export PATH=$PATH:/opt/local/bin:/opt/local/sbin/
export MANPATH=$MANPATH:/opt/local/man

#############################
# コマンド
export RSYNC_RSH=ssh
export CVS_RSH=ssh
export CVSROOT=~/CVSROOT
export GREP_COLOR='1;37;41'
export EDITOR=vi
export VIMHOME=$HOME/.vim
# less の動作
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'
case $LANG in
  ja_JP.UTF-8) JLESSCHARSET=utf-8 ; LV="-Ou8 -c" ;;
  ja_JP.*) JLESSCHARSET=japanese-utf ; LV="-Oej -c" ;;
  *) JLESSCHARSET=latin1 ; LV="-Al1 -c" ;;
esac
export JLESSCHARSET LV
if type lv &>/dev/null ; then
  PAGER=lv
elif type jless &>/dev/null ; then
  PAGER=jless
elif type less &>/dev/null ; then
  PAGER=less
else
  PAGER=more
fi
export PAGER
if type /usr/bin/lesspipe &>/dev/null; then
  LESSOPEN="| /usr/bin/lesspipe '%s'"
  LESSCLOSE="/usr/bin/lesspipe '%s' '%s'"
  export LESSOPEN LESSCLOSE
fi

export PATH=/opt/local/bin:/opt/local/sbin/:$PATH
export MANPATH=/opt/local/man:$MANPATH

#############################
# プログラミング
# perl がロケールに関するワーニングを出す場合に有効にする
#PERL_BADLANG=0 ; export PERL_BADLANG
# Java
#export JAVA_HOME=
#export PATH=$PATH:$JAVA_HOME/bin
#export CLASPATH=.:$JAVA_HOME/lib/tools.jar
# Tomcat
#export TOMCAT_HOME=
#export CATALINA_BASE=$TOMCAT_HOME
#export CATALINA_HOME=$TOMCAT_HOME
#export CATALINA_TMPDIR=$TOMAT_HOME/temp
#export CLASSPATH=$CLASSPATH:$TOMCAT_HOME/common/lib/servlet-api.jar:$TOMCAT_HOME/common/lib/jsp-api.jar
# SVN
#export SVNROOT=svn+ssh://localhost/var/svn/repo
#export SVN_SSH=ssh
#export SVN_EDITOR=/usr/bin/vim
# Hadoop
#export HADOOP_HOME=
#export PIGDIR=

#############################
# alias
alias ls='ls -F'
alias la='ls -a'
alias ll='ls -la'
alias cp='cp -p'
alias vi='vim'
alias tailf='tail -fn 100'
alias tailfn='tail -fn'
alias od='od -tx1z -Ax -v'
alias cp='cp -p'
alias sc='screen -r'
alias screen='screen -xR'
# バックアップファイルを表示 (削除は "chkbackups | xargs rm")
alias chkbackups='/usr/bin/find . -name "?*~" -o -name "?*.bak" -o -name ".[^.]?*~" -o -name ".[^.]?*.bak" -maxdepth 1'
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#############################
# 別ファイルの読み込み
# .bash_profile で使う
BASHRC_DONE=1
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
