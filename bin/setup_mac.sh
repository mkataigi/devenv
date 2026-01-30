#/bin/sh

if [ -e ./mac_defaults.sh ]; then
  echo "setup Mac defaults"
  ./mac_defaults.sh
else
  echo "skip setup Mac defaults"
fi

echo "Install brew"
brew tap Homebrew/bundle
brew bundle

echo "Install pip"
pip install -r pip.txt
