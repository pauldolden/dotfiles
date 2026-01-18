#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
else
    echo -e "${RED}Unsupported OS${NC}"
    exit 1
fi

echo -e "${GREEN}Starting dotfiles installation...${NC}"

# Install prerequisites based on OS
echo -e "${YELLOW}Installing prerequisites...${NC}"
if [[ "$OS" == "linux" ]]; then
    # Update package lists
    sudo apt update

    # Install essential packages
    sudo apt install -y git curl wget zsh neovim build-essential

    # Install optional but useful packages
    sudo apt install -y \
        ripgrep \
        fd-find \
        bat \
        fzf \
        tmux

elif [[ "$OS" == "mac" ]]; then
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages
    brew install git curl wget zsh neovim ripgrep fd bat fzf tmux
fi

# Clone dotfiles repository if not already cloned
DOTFILES_DIR="$HOME/.config"
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    echo -e "${YELLOW}Cloning dotfiles repository...${NC}"

    # Backup existing .config if it exists and is not a git repo
    if [[ -d "$DOTFILES_DIR" ]]; then
        echo -e "${YELLOW}Backing up existing .config to .config.backup${NC}"
        mv "$DOTFILES_DIR" "$DOTFILES_DIR.backup"
    fi

    git clone https://github.com/pauldolden/dotfiles.git "$DOTFILES_DIR"
else
    echo -e "${GREEN}Dotfiles repository already exists, pulling latest changes...${NC}"
    cd "$DOTFILES_DIR"
    git pull
fi

cd "$DOTFILES_DIR"

# Install Zsh plugins
echo -e "${YELLOW}Installing Zsh plugins...${NC}"

# zsh-syntax-highlighting
if [[ ! -d "$DOTFILES_DIR/zsh/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$DOTFILES_DIR/zsh/zsh-syntax-highlighting"
fi

# zsh-autosuggestions
if [[ ! -d "$DOTFILES_DIR/zsh/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$DOTFILES_DIR/zsh/zsh-autosuggestions"
fi

# zsh-completions (if not already present)
if [[ ! -d "$DOTFILES_DIR/zsh/zsh-completions" ]]; then
    git clone https://github.com/zsh-users/zsh-completions.git \
        "$DOTFILES_DIR/zsh/zsh-completions"
fi

# Install Powerlevel10k
echo -e "${YELLOW}Installing Powerlevel10k...${NC}"
if [[ ! -d "$DOTFILES_DIR/p10k" ]]; then
    mkdir -p "$DOTFILES_DIR/p10k"
fi

if [[ ! -d "$DOTFILES_DIR/p10k/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$DOTFILES_DIR/p10k/powerlevel10k"
fi

# Create p10k config if it doesn't exist
if [[ ! -f "$DOTFILES_DIR/p10k/.p10k.zsh" ]]; then
    echo -e "${YELLOW}Note: p10k config not found. You'll need to run 'p10k configure' after installation.${NC}"
fi

# Create symlinks
echo -e "${YELLOW}Creating symlinks...${NC}"

# Function to safely create symlinks
create_symlink() {
    local source=$1
    local target=$2

    if [[ -L "$target" ]]; then
        # Remove existing symlink
        rm "$target"
    elif [[ -f "$target" ]] || [[ -d "$target" ]]; then
        # Backup existing file/directory
        echo -e "${YELLOW}Backing up existing $target to ${target}.backup${NC}"
        mv "$target" "${target}.backup"
    fi

    ln -s "$source" "$target"
    echo -e "${GREEN}Created symlink: $target -> $source${NC}"
}

# Symlink zsh config
if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

if [[ -f "$DOTFILES_DIR/zsh/.zprofile" ]]; then
    create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
fi

# Symlink p10k config if it exists
if [[ -f "$DOTFILES_DIR/p10k/.p10k.zsh" ]]; then
    create_symlink "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# Symlink git config if it exists
if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

# Change default shell to zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo -e "${YELLOW}Changing default shell to zsh...${NC}"

    # Add zsh to valid shells if not already there
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi

    chsh -s "$(which zsh)"
    echo -e "${GREEN}Default shell changed to zsh. Please log out and log back in for changes to take effect.${NC}"
fi

# Install Neovim dependencies
echo -e "${YELLOW}Setting up Neovim...${NC}"

# Install Node.js if not present (required for some nvim plugins)
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js...${NC}"
    if [[ "$OS" == "linux" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    elif [[ "$OS" == "mac" ]]; then
        brew install node
    fi
fi

# Lazy.nvim will auto-install on first nvim launch
echo -e "${GREEN}Neovim is configured. Plugins will auto-install on first launch.${NC}"

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. If this is your first time, log out and log back in (or run: exec zsh)"
echo -e "2. If p10k config doesn't exist, run: p10k configure"
echo -e "3. Launch nvim - plugins will auto-install on first launch"
echo -e "4. Customize your configs in $DOTFILES_DIR"
echo ""
echo -e "${GREEN}Enjoy your dotfiles!${NC}"
