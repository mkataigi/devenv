#!/bin/sh

usage_exit() {
    echo "Usage: $0 [-f]" 1>&2
    exit 1
}

if [ "x$CWD" = "x" ]; then
  CWD=$(cd $(dirname $0);cd ..;pwd)
fi

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
    todir=$2
    fromdir=$CWD
    force=$FORCE_FLAG

    if [ "x$todir" = "x" ]; then
      todir=$HOME
    fi

    if [ -d "$fromdir/$name" -o -f "$fromdir/$name" -o -L "$fromdir/$name" ]; then
        if [ -d "$todir/$name" -o -f "$todir/$name" -o -L "$todir/$name" ]; then
            if [ $force -eq 1 ]; then
                echo "rm -fr $todir/$name"
                rm -fr $todir/$name
            else
                echo "exists $todir/$name"
                return 0
            fi
        fi

        echo "ln -s $fromdir/$name $todir/$name"
        ln -s "$fromdir/$name" "$todir/$name"
    else
        echo "not found $fromdir/$name"
    fi
}

make_dir() {
    name=$1
    dir=$2

    if [ "x$dir" = "x" ]; then
      dir=$HOME
    fi

    if [ ! -e $dir/$name ]; then
        echo "mkdir $dir/$name"
        mkdir $dir/$name
    else
        echo "exists $dir/$name"
    fi
}

