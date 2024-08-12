# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel9k/powerlevel9k"


# List of plugins to load (beware of performance impact with too many)
plugins=(git)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# Set the preferred editor for local and remote sessions
# Adjust as needed for your workflow
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Set compilation flags if needed
# export ARCHFLAGS="-arch x86_64"

# Personal aliases and functions can be added here
# Example aliases
# alias zshconfig="nano ~/.zshrc"
# alias ohmyzsh="nano ~/.oh-my-zsh"

# Initialize pyenv
eval "$(pyenv init --path)"

