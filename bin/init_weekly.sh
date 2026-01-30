#!/bin/sh

brew update
brew upgrade

docker images -qf dangling=true | xargs docker rmi
