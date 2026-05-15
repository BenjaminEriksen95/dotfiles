# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="eastwood"


# List of plugins to load (beware of performance impact with too many)
plugins=(git zsh-autosuggestions fzf)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# User configuration

# bob – Neovim version manager
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

source <(fzf --zsh)

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

# 
eval "$(zoxide init zsh)"

 zi() {
  local dir
  dir=$(zoxide query -l | fzf) && z "$dir"
 }

zvim() {
  local dir
  dir=$(zoxide query -l | fzf)
  [ -n "$dir" ] && z "$dir" && nvim .
 }

# Copy and paste aliases
alias copy="pbcopy"  # e.g. echo "hello" | copy
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

# GitHub Copilot with whitelisted dev tools (read-only analysis tools from copilot-instructions)
alias cop='gh copilot -- \
  --deny-tool "shell(find)" \
  --allow-tool "shell(fd)" \
  --allow-tool "shell(bd)" \
  --allow-tool "shell(rg)" \
  --allow-tool "shell(xargs)" \
  --allow-tool "shell(git diff)" \
  --allow-tool "shell(git status)" \
  --allow-tool "shell(git log)" \
  --allow-tool "shell(cat)" \
  --allow-tool "shell(printf)" \
  --allow-tool "shell(head)" \
  --allow-tool "shell(eza)" \
  --allow-tool "shell(jq)" \
  --allow-tool "shell(tokei)" \
  --allow-tool "shell(sg)" \
  --allow-tool "shell(jq)" \
  --allow-tool "shell(fzf)"'

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -s '^f' 'yazi\n'

export XDG_CONFIG_HOME="$HOME/.config"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Added by Ix installer
export PATH="$HOME/.local/bin:$PATH"

# yazi — cd on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# GNU coreutils (required by git-quick-stats)
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# bun completions
[ -s "/Users/benjamin/.bun/_bun" ] && source "/Users/benjamin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Global skills orchestrator
export PATH="$HOME/dotfiles/skills/bin:$PATH"
