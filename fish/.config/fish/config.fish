if status is-interactive
    # Commands to run in interactive sessions can go here
end

set EDITOR nvim

alias python="python3"

set -gx PATH $HOME/.pyenv/bin $PATH
pyenv init - | source


# Solves pylint cannot find project packages
if not contains . $PYTHONPATH
    set -x PYTHONPATH $PYTHONPATH .
end



# Add GNU Core Utilities to PATH - required for git-quick-stats
set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
alias date='gdate'

set -x XDG_CONFIG_HOME $HOME/.config
