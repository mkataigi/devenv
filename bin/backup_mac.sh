#/bin/sh

echo "Backup defaults"
defaults read > mac_defaults.txt

echo "Backup Chrome Bookmarks"
if [ -d $HOME/Library/Application\ Support/Google/Chrome/Default/ ]; then
  cp $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks Chrome_Bookmarks.txt
elif [ -d $HOME/Library/Application\ Support/Google/Chrome/Profile\ 2/ ]; then
  cp $HOME/Library/Application\ Support/Google/Chrome/Profile\ 2/Bookmarks Chrome_Bookmarks.txt
else
  echo "Not found Chrome Bookmarks"
fi

echo "Backup Applications"
ls /Applications > applications.txt

echo "Backup brew"
brew bundle dump --force

#echo "Backup pip"
#pip freeze > pip.txt

echo "git commit & push"
git commit -a -m "backup at `date '+%Y/%m/%d'`"
git push origin master
