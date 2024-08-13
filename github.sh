#!/bin/bash

# Exit on error
set -e

# Function to set up SSH config and keys
setup_ssh() {
    # Create .ssh directory if it doesn't exist
    mkdir -p ~/.ssh

    # Stow the ssh configuration files
    stow ssh

    # Generate SSH key
    ssh-keygen -t ed25519 -C "benja.e95@gmail.com" -f ~/.ssh/id_ed25519 -N ""

    # Start the SSH agent
    eval "$(ssh-agent -s)"

    # Add SSH private key to the agent
    ssh-add ~/.ssh/id_ed25519

    # Display the SSH key and instructions to add it to GitHub
    echo "Your SSH key has been generated. Copy the following public key and add it to your GitHub account:"
    cat ~/.ssh/id_ed25519.pub

    echo "Visit https://github.com/settings/keys to add the key."

    echo "Test using 'ssh -T git@github.com' - do not use Work wifi for this!"

    echo "SSH setup complete."
}


# Run the setup function
setup_ssh

