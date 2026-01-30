#!/bin/bash

function get_main_branch {
  dir=$1
  branches=`git -C $dir branch`

  for branch in develop main master; do
    if echo "$branches" | grep -q -e " $branch$"; then
      echo -n "$branch"
      return
    fi
  done
}

function git_clean {
  git remote prune origin
  git branch --merged | grep -ve '\*\|develop\|master\|main' | xargs git branch -d
}

function update {
  dir=$1
  if [[ -d "$dir" && -d "$dir/.git" ]]; then
    echo "===== UPDATING $dir ====="

    main_branch=`get_main_branch $dir`
    if [ "x$main_branch" == "x" ]; then
      echo "# main branch : not found"
      continue
    fi
    echo "# main branch : $main_branch"

    echo "# git fetch"
    git -C $dir fetch --all
    echo "# git pull"
    git -C $dir pull origin $main_branch:$main_branch
    echo "# git clean"
    git_clean

    # print git info
    echo "# print current branches"
    git -C $dir branch | cat
    echo "# print current stashes"
    git -C $dir stash list | cat
  fi
}

TARGET_DIR=$1
if [ "x$TARGET_DIR" == "x" ]; then
  TARGET_DIR="."
fi

for dir in `ls $TARGET_DIR`; do
  if [ "x$dir" == "x." -o "x$dir" == "x.." ]; then
    continue
  fi
  update "$TARGET_DIR/$dir"
done
