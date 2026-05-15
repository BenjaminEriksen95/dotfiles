#!/bin/bash

# Exit on error
set -e

# Function to set up SSH config and keys for work GitHub account (be_festina)
setup_ssh() {
    # Create .ssh directory if it doesn't exist
    mkdir -p ~/.ssh

    # Stow the ssh configuration files
    stow ssh

    # Generate SSH key
    ssh-keygen -t ed25519 -C "be@festinafinance.com" -f ~/.ssh/id_work -N ""

    # Start the SSH agent
    eval "$(ssh-agent -s)"

    # Add SSH private key to the agent
    ssh-add ~/.ssh/id_work

    # Display the SSH key and instructions to add it to GitHub
    echo "Your SSH key has been generated. Copy the following public key and add it to your GitHub account (be_festina):"
    cat ~/.ssh/id_work.pub

    echo "Visit https://github.com/settings/keys to add the key."

    echo "Test using 'ssh -T git@github.com-work' after adding the key."

    echo "SSH setup complete."
}


# Run the setup function
setup_ssh

