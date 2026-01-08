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
create_symlink "$DOTFILE_DIR/.aliases" "$HOME/.aliases"
create_symlink "$DOTFILE_DIR/.tool-versions" "$HOME/.tool-versions"

# ============================================
# Setup asdf
# ============================================

echo "Setting up asdf..."

# Source asdf (Homebrew installation)
if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
    . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# Install asdf plugins
echo "Installing asdf plugins..."

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
asdf plugin add python https://github.com/asdf-vm/asdf-python.git 2>/dev/null || true
asdf plugin add golang https://github.com/asdf-vm/asdf-golang.git 2>/dev/null || true
asdf plugin add terraform https://github.com/asdf-vm/asdf-hashicorp.git 2>/dev/null || true
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git 2>/dev/null || true

# Install tool versions from .tool-versions
echo "Installing tool versions..."
asdf install

# ============================================
# Install global npm packages
# ============================================

echo "Installing global npm packages..."
npm install -g @anthropic-ai/claude-code

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
# Install k3d
# ============================================

if ! command -v k3d &> /dev/null; then
    echo "Installing k3d..."
    mkdir -p "$HOME/.local/bin"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | K3D_INSTALL_DIR="$HOME/.local/bin" USE_SUDO=false bash
else
    echo "k3d already installed"
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
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Verify tools: asdf current"
echo ""
