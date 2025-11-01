#!/usr/bin/env bash
# DevBox OS - Shell Configuration Script
# Sets up fish and zsh configurations

set -euo pipefail

echo "🐚 DevBox OS - Configuring shells..."

# Create fish config directory
mkdir -p /etc/skel/.config/fish

# Basic fish config for new users
cat > /etc/skel/.config/fish/config.fish << 'EOF'
# DevBox OS - Fish Shell Configuration

# Set greeting
set fish_greeting "Welcome to DevBox OS 🐳"

# Modern CLI aliases
if command -v eza > /dev/null
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
    alias tree='eza --tree --icons'
end

if command -v bat > /dev/null
    alias cat='bat --style=plain'
end

# Zoxide (better cd)
if command -v zoxide > /dev/null
    zoxide init fish | source
    alias cd='z'
end

# Development aliases
alias dev='distrobox-enter dev-fedora'
alias ubuntu='distrobox-enter dev-ubuntu'

# Git aliases
alias gs='git status'
alias gp='git pull'
alias gc='git commit'
alias gd='git diff'

# Container aliases
alias dps='podman ps'
alias dimg='podman images'
EOF

# Create zshrc for zsh users
cat > /etc/skel/.zshrc << 'EOF'
# DevBox OS - Zsh Configuration

# Basic prompt
PROMPT='%F{cyan}devbox%f %F{blue}%~%f %# '

# Modern CLI aliases
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
    alias tree='eza --tree --icons'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=plain'
fi

# Zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# Development aliases
alias dev='distrobox-enter dev-fedora'
alias ubuntu='distrobox-enter dev-ubuntu'
EOF

echo "✅ Shell configurations created"
echo "   Fish config: /etc/skel/.config/fish/config.fish"
echo "   Zsh config: /etc/skel/.zshrc"
