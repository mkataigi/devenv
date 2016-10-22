# ---- language-env DON'T MODIFY THIS LINE!
# .bash_profile は、ログイン時に実行される。
# gitのbash_completion設定
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -f ~/.bashrc ]; then
  # ただし、すでに .bash_profile が .bashrc を実行していたら、
  # 複重しては実行しない。
  if [ -z "$BASHRC_DONE" ]; then
    . ~/.bashrc
  fi
fi
# ---- language-env end DON'T MODIFY THIS LINE!

[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # Load RVM into a shell session *as a function*
