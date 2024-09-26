# Function to check if Homebrew is installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Ensure Homebrew is in PATH
        eval "$(brew shellenv)"
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    stow -t ~ zsh
    stow -t ~ nvim
    stow -t ~ kitty
    rm -rf ~/.config/fish
    stow -t ~ fish
    stow -t ~ lazygit
    stow -t ~ ssh
    bash ./github.sh
}

# Main script
main() {
    # Ensure Homebrew is in PATH
    if ! command -v brew &> /dev/null; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
    install_homebrew
    install_from_brewfile
    stow_dotfiles
}

main
