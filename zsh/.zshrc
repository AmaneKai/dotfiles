# ==============================================================================
# ZSH CONFIGURATION (LINUX OPTIMIZED)
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

# --- 2. Environment Variables ---
export EDITOR="nvim"
export VISUAL="nvim"
export QT_QPA_PLATFORMTHEME="qt5ct"

# Graphics / Mesa Settings
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export vblank_mode=0

# --- 3. Path Configuration ---
typeset -U path
path=(
    "$HOME/.cargo/bin"
    "$HOME/Dotfiles/bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/nvim/mason/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.bun/bin"
    "$HOME/.ghcup/bin"
    "/usr/bin"
    $path
)

# --- 4. Tool Initializations ---
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
eval "$(zoxide init zsh)"

# Keybindings (CTRL-f: Open tmux-sessionizer)
bindkey -s '^f' 'tmux-sessionizer\n'

# --- 5. Aliases ---

# General
alias vi="nvim"

# Eza (Modern LS)
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias l="eza --tree --git-ignore --icons --level=3 --group-directories-first"

# Dev Tools
alias grun="./gradlew run -q --console=plain"
alias jqinit='npm init -y && npm install --save-dev @types/jquery'

# Download Audio/Video
alias ytdl-mp3="yt-dlp -x --audio-format mp3 --audio-quality 0"
alias ytdl-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

# Git
alias g='git'
compdef g=git

# --- 6. Custom Functions ---
ginit() {
    local project_name=$1
    if [[ -z "$project_name" ]]; then
        echo "Usage: ginit <project-name>"; return 1
    fi
    gradle init --type java-application --package "$project_name"
}

# --- 7. Final Initializations ---
# Go path fix
if command -v go &>/dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Ghcup (Haskell)
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# bun completions
[ -s "/home/amane/.bun/_bun" ] && source "/home/amane/.bun/_bun"

alias preflight="bunx prisma generate && bun run check && bun run test && bun run build"

# opencode
export PATH=/home/amane/.opencode/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-26-openjdk

# Organize Downloads on terminal startup
"$HOME/.local/bin/organize-downloads" --quiet
