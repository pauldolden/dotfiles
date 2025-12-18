## Refresh
alias refresh='exec zsh -l'
alias rf='exec zsh -l'
## Quit
alias q='exit'
alias quit='exit'
alias quite='exit'
## Git
alias lg='lazygit'
## Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
## Zsh
alias zshrc='nvim ~/.config/zsh/.zshrc'
alias zshenv='nvim ~/.zshenv'
alias zprofile='nvim ~/.config/zsh/.zprofile'
## Dotfiles
alias dot='cd ~/.config/ && nvim'
alias appsup='cd /Users/PDolden/Library/Application\ Support/ && nvim'
## Printenv
alias pe='printenv'
# Projects
alias proj='cd ~/dev/personal/'
alias pp='cd ~/Development/Projects/personal'
alias wd='cd ~/Development/Projects/weirddeer'
# Docker & Kubernetes
alias dpull='docker pull --platform linux/amd64'
alias kc='kubectl'
alias k='kubectl'
alias k9='k9s'
# System monitoring
alias mon='btop'
# File listing
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons'
# Notes (Obsidian vault)
alias notes='cd ~/vault && nvim'
alias vault='cd ~/vault && nvim'
alias today='nvim ~/vault/Daily\ Notes/$(date +%Y-%m-%d).md'
# File management
alias y='yazi'
# Zoxide (smart cd)
alias cd='z'
alias cdi='zi'  # Interactive selection
