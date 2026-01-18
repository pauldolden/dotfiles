# Dotfiles

Personal dotfiles configuration including Neovim, Zsh, Git, and various other tools.

## Quick Installation

For a fresh system (Raspberry Pi, new Linux machine, etc.):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/pauldolden/dotfiles/main/install.sh)
```

Or clone and run manually:

```bash
git clone https://github.com/pauldolden/dotfiles.git ~/.config
cd ~/.config
chmod +x install.sh
./install.sh
```

## What's Included

- **Neovim**: Complete IDE setup with LSP, autocompletion, and plugins
- **Zsh**: Shell configuration with aliases, functions, and exports
- **Git**: Git configuration and aliases
- **P10k**: Powerlevel10k prompt theme
- **Yazi**: File manager configuration
- **Lazygit**: Git TUI configuration
- **K9s**: Kubernetes TUI configuration
- **Ghostty**: Terminal emulator configuration

## Manual Installation (Advanced)

If you prefer to install components manually:

### Prerequisites

- [p10k](https://github.com/romkatv/powerlevel10k)
- [Btop](https://github.com/aristocratos/btop)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
