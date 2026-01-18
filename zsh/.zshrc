# Source configuration files
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/functions.zsh

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
export COREPACK_ENABLE_AUTO_PIN=0

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() {
  unset -f nvm node npm
  lazy_load_nvm
  nvm "$@"
}

# Source plugins
export PATH="$HOME/zig:$PATH"
source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-syntax-highlighting/theme.zsh

# Set up completion (optimized - only run dump once per day)
autoload -Uz compinit
setopt EXTENDEDGLOB
local zcompdump="$HOME/.zcompdump"
# Check if zcompdump is older than 24 hours
if [[ -n $zcompdump(#qNmh-24) ]]; then
  # Use cached version if less than 24 hours old
  compinit -C -d "$zcompdump"
else
  # Regenerate completion dump
  compinit -d "$zcompdump"
fi
unsetopt EXTENDEDGLOB

# Update tmux pane title
function update_tmux_pane_title() {
    if [[ -n "$TMUX" ]]; then
        tmux rename-window "${PWD:t}"
    fi
}
precmd_functions+=update_tmux_pane_title

# Lazy load Google Cloud SDK
lazy_load_gcloud() {
  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
  fi
  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
  fi
}

gcloud() {
  unset -f gcloud gsutil
  lazy_load_gcloud
  gcloud "$@"
}

gsutil() {
  unset -f gcloud gsutil
  lazy_load_gcloud
  gsutil "$@"
}

# Initialize Atuin
eval "$(atuin init zsh)"

# pnpm configuration
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Set FZF options
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --height=80% \
  --preview-window=right:60% \
  --bind='ctrl-/:toggle-preview' \
  --bind='ctrl-u:preview-half-page-up' \
  --bind='ctrl-d:preview-half-page-down' \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

# Use fd for faster file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Use bat for file preview with syntax highlighting
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:toggle-preview'
"

# Preview directory contents with eza/ls
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}'
"

eval "$(starship init zsh)"

# Initialize zoxide (smarter cd)
eval "$(zoxide init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# Auto-load nvm default version on shell start
export PATH="$HOME/.nvm/versions/node/v25.2.1/bin:$PATH"
