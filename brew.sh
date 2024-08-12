#!/bin/bash

# Exit on error
set -e

# Function to check if Homebrew is installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # The brew shellenv setup should already be in your stowed .zprofile
        echo "Homebrew installed."
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install packages from Brewfile
install_from_brewfile() {
    if [ -f "Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file=./Brewfile
    else
        echo "Brewfile not found. Skipping installation."
    fi
}

# Function to stow dotfiles
stow_dotfiles() {
    echo "Stowing dotfiles..."
    stow -t ~ zsh
}

# Main script
main() {
    install_homebrew
    stow_dotfiles
    install_from_brewfile
}

main
