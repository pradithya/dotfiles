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

# asdf version manager (manages Node.js, Python, Go, Terraform, kubectl, etc.)
export ASDF_DIR="$HOME/.asdf"
[ -f "$ASDF_DIR/asdf.sh" ] && . "$ASDF_DIR/asdf.sh"

# Go (after asdf to use asdf-managed Go)
export GOBIN="$(go env GOBIN)"
[ -n "$GOBIN" ] && export PATH="$PATH:$GOBIN"

# Krew (kubectl plugin manager)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# k3d
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# Environment Variables
# ============================================

export EDITOR='code --wait'
export KUBE_EDITOR='code --wait'

# ============================================
# Load Aliases
# ============================================

source "$HOME/.aliases"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/pradithya/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
