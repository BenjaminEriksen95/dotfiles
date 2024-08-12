#!/bin/bash


mkdir -p "$HOME/.config"

# Navigate to dotfiles directory
cd "$(dirname "$0")"


##### TMUX
stow -t ~ tmux

# Check if tmux server is running, and start a new session if not
if ! tmux has-session 2>/dev/null; then
    echo "No tmux server running. Starting a new tmux session..."
    tmux new-session -d -s setup-session 'true'
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Cloning tmux pling manager(tmp)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Reload tmux configuration to recognize tpm
echo "Reloading tmux configuration..."
tmux source-file ~/.tmux.conf

# Install plugins via tpm
tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh

##### NVIM

stow -t ~ nvim

