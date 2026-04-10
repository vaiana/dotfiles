# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Minimal prompt - no fancy symbols, clean for copy-paste
ZSH_THEME="minimal"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Vi mode for command line editing
set -o vi

#################
# Aliases
#################
alias stow='stow --target=$HOME'
alias vim="nvim"
alias vi="nvim"
alias scp="noglob scp"
alias cr="claude --rc --permission-mode plan"                   # interactive claude session, monitorable via mobile app
alias crd="claude --rc --dangerously-skip-permissions"  # same, no permission prompts
alias btc="bt-connect"
alias btcl="bt-connect --list"


export BROWSER="brave-work"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"
