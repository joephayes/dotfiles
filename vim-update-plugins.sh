#!/bin/bash

set -ex

tmux new-session -d "sleep 1"             # Make sure tmux server is running, but that the created session will clean itself.
sleep 0.1                                 # Wait for tmux server initialization to complete.
#########
$HOME/.tmux/plugins/tpm/bin/clean_plugins
$HOME/.tmux/plugins/tpm/bin/update_plugins all
nvim +PlugInstall! +PlugUpdate! +PlugUpgrade +qall
python3 -m pip install --user --upgrade pynvim
#python2 -m pip install --user --upgrade pynvim
npm install -g neovim
nvim +UpdateRemotePlugins +qall
