# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="eastwood"


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

# Copy and paste aliases
alias y="pbcopy"
alias p="pbpaste"
alias pn="p | nvim -"

# Copy last command output
alias cl="fc -ln -1 | pbcopy"   # zsh/bash friendly

# Copy contents of a file
alias cf="cat"                  # or...
alias cfile='cat "$1" | pbcopy' # use like: cfile myfile.txt

# Paste to file
alias pfile='pbpaste >'

# Grep something and copy it
alias gc='grep "$1" "$2" | pbcopy'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
