# Dotfiles

## Installation

```bash
git clone https://github.com/yourusername/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

The install script will:
1. Install Homebrew (if not present)
2. Install packages from Brewfile
3. Install Oh My Zsh and plugins
4. Create symlinks for config files
5. Setup asdf and install tool versions
6. Install Claude CLI
7. Install kubectl krew

## Updating

```bash
cd ~/dotfile
git pull
brew bundle --file=Brewfile
asdf install
```
