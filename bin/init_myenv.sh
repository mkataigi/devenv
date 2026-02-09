#!/bin/sh

CWD=$(cd $(dirname $0);cd ..;pwd)

source ${CWD}/bin/init_tools.sh


make_link ".bash_profile"
make_link ".bash_logout"
make_link ".bashrc"
make_link ".profile"
make_link ".zshenv"
make_link ".zshrc"
make_link ".zprofile"
make_link ".gitconfig"
make_link ".screenrc"
make_link ".tmux.conf"
make_link ".vimrc"
make_link ".vim"
make_link ".emacs"
make_link ".rgignore"
make_link ".ssh/config"
make_link "bin"
make_link ".claude"
make_link ".claude.json"
make_link ".codex"
make_link ".devcontainers"

make_link "Code/User/settings.json" $HOME'/Library/Application Support'

make_dir ".vimback"
make_dir ".vimtmp"
