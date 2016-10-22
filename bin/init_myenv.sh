#!/bin/sh

usage_exit() {
        echo "Usage: $0 [-f]" 1>&2
        exit 1
}

CWD=$(cd $(dirname $0);cd ..;pwd)

FORCE_FLAG=0

while getopts f OPT
do
    case $OPT in
        f)  FORCE_FLAG=1 ;;
        \?) usage_exit ;;
    esac
done

shift $((OPTIND - 1))


make_link() {
    name=$1
    dir=$CWD
    force=$FORCE_FLAG

    if [ -d "$dir/$name" -o -f "$dir/$name" -o -L "$dir/$name" ]; then
        if [ -d "$HOME/$name" -o -f "$HOME/$name" -o -L "$HOME/$name" ]; then
            if [ $force -eq 1 ]; then
                echo "rm -fr $HOME/$name"
                rm -fr $HOME/$name
            else
                echo "exists $HOME/$name"
                return 0
            fi
        fi

        echo "ln -s $dir/$name $HOME/$name"
        ln -s $dir/$name $HOME/$name
    else
        echo "not found $dir/$name"
    fi
}

make_dir() {
    name=$1

    if [ ! -e $HOME/$name ]; then
        echo "mkdir $HOME/$name"
        mkdir $HOME/$name
    else
        echo "exists $HOME/$name"
    fi
}


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
make_link "bin"

make_dir ".vimback"
make_dir ".vimtmp"
