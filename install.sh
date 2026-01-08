#!/bin/bash

set -e

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==================================="
echo "  Dotfiles Installation Script"
echo "==================================="

# ============================================
# Install Homebrew
# ============================================

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# ============================================
# Install packages from Brewfile
# ============================================

echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILE_DIR/Brewfile"

# ============================================
# Install Oh My Zsh
# ============================================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# ============================================
# Install Zsh plugins
# ============================================

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ============================================
# Create symlinks
# ============================================

echo "Creating symlinks..."

create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        echo "Removing existing symlink: $dest"
        rm "$dest"
    elif [ -f "$dest" ]; then
        echo "Backing up existing file: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi

    echo "Linking: $src -> $dest"
    ln -s "$src" "$dest"
}

create_symlink "$DOTFILE_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILE_DIR/.gitconfig" "$HOME/.gitconfig"

# ============================================
# Install kubectl krew plugin manager
# ============================================

if ! command -v kubectl-krew &> /dev/null; then
    echo "Installing kubectl krew..."
    (
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm64/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
    )
fi

# ============================================
# Setup NVM
# ============================================

if [ ! -d "$HOME/.nvm" ]; then
    echo "Setting up NVM directory..."
    mkdir -p "$HOME/.nvm"
fi

# ============================================
# Setup pyenv
# ============================================

if command -v pyenv &> /dev/null; then
    echo "Installing latest Python via pyenv..."
    pyenv install 3.12 --skip-existing
    pyenv global 3.12
fi

# ============================================
# Final steps
# ============================================

echo ""
echo "==================================="
echo "  Installation Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "1. Update .gitconfig with your name and email"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Install Node.js: nvm install --lts"
echo ""
