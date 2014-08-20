#!/usr/bin/env bash

cd $(dirname "$0")

git fetch
git reset --hard origin/master

vim +BundleInstall! +BundleClean +qall

. ~/.bashrc
