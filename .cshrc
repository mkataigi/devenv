# ---- language-env DON'T MODIFY THIS LINE!
# ----- 基本的な設定 -----
# XIM サーバーの名前を定義する
# (XIM は、languge-env だけで使うシェル変数です)
set XIM=kinput2
# xprop は、xbase-clients パッケージに含まれます
if ( $?WINDOWID && -x /usr/bin/X11/xprop ) then
  # X Window System 上で走ってるけど X Window System と通信する権限が
  # ないとき (su したときなど) への対策
  xprop -id $WINDOWID >& /dev/null || unset WINDOWID
endif
if ( $?WINDOWID && -x /usr/bin/X11/xprop ) then
  set XPROP=`xprop -id $WINDOWID WM_CLASS` >&/dev/null
  set CLASS=`echo $XPROP | sed -e 's/.*WM_CLASS(STRING) = "//' -e 's/[",]//g'`
  switch ("$CLASS")
  case *kterm* :
    set LANG=ja_JP.UTF-8 ; breaksw
  case *krxvt* :
    set LANG=ja_JP.UTF-8 ; breaksw
  case *k[aw]term* :
    set LANG=ja_JP.UTF-8 ; breaksw
  case *UXTerm* :
    set LANG=ja_JP.UTF-8 ; breaksw
  case *hanterm* :
    set LANG=ko_KR.eucKR ; breaksw
  case *caterm* :
    set LANG=zh_TW.Big5 ; breaksw
  case *crxvt-big5* :
    set LANG=zh_TW.Big5 ; breaksw
  case *crxvt-gb* :
    set LANG=zh_CN.GB2312 ; breaksw
  case *[xa]term* :
    set LANG=C ; breaksw
  default:
    breaksw
  endsw
else
  switch ($TERM)
    case linux:
      set LANG=C ; breaksw
    case xterm:
      breaksw
    case jfbterm:
      breaksw
    default:
      set LANG=ja_JP.UTF-8
  endsw
endif
switch ($LANG)
  case ja_JP.UTF-8:
    set JLESSCHARSET=utf-8 ; set LV=-Ou8 ; breaksw
  case ja_JP.*:
    set JLESSCHARSET=japanese-euc ; set LV=-Oej ; breaksw
  default:
    set JLESSCHARSET=latin1 ; set LV=-Al1
endsw
setenv LANG $LANG
setenv JLESSCHARSET $JLESSCHARSET
setenv LV $LV
setenv PAGER more
foreach pager ( lv jless less )
  if ( -x /usr/bin/$pager ) then
    setenv PAGER $pager
    break
  endif
end
alias jfbterm '(setenv LANG ja_JP.UTF-8 ; exec /usr/bin/jfbterm \!*)'
# XMODIFIERS を setenv しないのは、emacs が Segmentation Fault を起こすから
# ただし、この方法だと、Debian メニューシステムからの起動には対応できない。
alias xemacs '(unsetenv XMODIFIERS ; exec \xemacs \!*)'
# perl がロケールにかんするワーニングを出す場合に有効にしてください。
# setenv PERL_BADLANG 0
# ----- お好みに応じて -----
# ls の動作。man ls 参照
if ( $TERM == "dumb" || $TERM == "emacs" ) then
  alias ls '/bin/ls -F'
else
  alias ls '/bin/ls -F --color=auto'
endif
# 標準エディタを vi にする。Debian Policy Manual 参照
setenv EDITOR vi
# プロンプト。man tcsh 参照
set promptchars='%#'
set prompt='%B%~%#%b '
# mh がインストールされていたら、PATH に加える。
[ -x /usr/bin/mh/mhmail ]
if ($status == 0) then
  set path=($path /usr/bin/mh)
endif
# ファイルを作るとき、どんな属性で作るか。man umask 参照
umask 022
# less の動作。man less 参照
setenv LESS -M
if ( -x /usr/bin/lesspipe ) then
  setenv LESSOPEN "| /usr/bin/lesspipe '%s'"
  setenv LESSCLOSE "/usr/bin/lesspipe '%s' '%s'"
endif
# Ctrl-D でログアウトするのを抑制する。man tcsh 参照
set ignoreeof
# カレントディレクトリのバックアップファイルを表示する
# (削除する際は "chkbackups | xargs rm" を実行のこと)
alias chkbackups '/usr/bin/find . -name "?*~" -o -name "?*.bak" -o -name ".[^.]?*~" -o -name ".[^.]?*.bak" -maxdepth 1'
# X Window System 上での設定
if ( $?DISPLAY ) then
  # 端末ウィンドウのタイトルを変更する
  alias xtitle '/bin/echo -e "\033]0;\!*\007\c"'
endif
# ---- language-env end DON'T MODIFY THIS LINE!
