# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  docker
  kubectl
  terraform
  golang
  npm
  python
  asdf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================
# PATH Configuration
# ============================================

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# asdf version manager (manages Node.js, Python, Go, Terraform, kubectl, etc.)
export ASDF_DIR="$HOME/.asdf"
[ -f "$ASDF_DIR/asdf.sh" ] && . "$ASDF_DIR/asdf.sh"

# Krew (kubectl plugin manager)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ============================================
# Environment Variables
# ============================================

export EDITOR='code --wait'
export KUBE_EDITOR='code --wait'

# ============================================
# Load Aliases
# ============================================

source "$HOME/.aliases"
