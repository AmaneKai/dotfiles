# ==============================================================================
# ZSH CONFIGURATION
# ==============================================================================

# --- 1. Framework Initialization (Oh My Zsh) ----------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# --- 2. Environment Variables -------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
export CATALINA_HOME="/usr/share/tomcat9"
export QT_QPA_PLATFORMTHEME="qt5ct"

# Graphics / Mesa Settings
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export vblank_mode=0

# --- 3. Path Configuration ----------------------------------------------------
# Define paths in an array for readability, then join them
typeset -U path  # -U ensures unique entries (no duplicates)

# Prepend paths (Priority order)
path=(
    "$HOME/Dotfiles/bin"
    "$HOME/.local/bin"
    "$HOME/Library/Python/3.14/bin"
    "$HOME/.local/share/nvim/mason/bin"
    "$HOME/.npm-global/bin"
    "/opt/homebrew/opt/openjdk/bin"
    "/usr/local/mysql/bin"
    "$CATALINA_HOME/bin"
    $path
)

# --- 4. Tool Initializations --------------------------------------------------
# Rust/Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Zoxide (Smart cd)
eval "$(zoxide init zsh)"

# Keybindings
# CTRL-f: Open tmux-sessionizer
bindkey -s '^f' 'tmux-sessionizer\n'

# --- 5. Aliases ---------------------------------------------------------------

# General
alias vi="nvim"
alias ctags="/opt/homebrew/bin/ctags"
alias fastfetch="anifetch anifetch/src/anifetch/assets/badapple.mp4"

# Eza (LS Replacement) - Modern Directory Listing
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lag --icons"
alias l="eza --tree --git-ignore --icons --level=5 --group-directories-first"
alias lw="eza --tree --git-ignore --no-permissions --no-user --no-time --no-filesize --icons --level=5"

# Eza Tree Shortcuts (Depth 1-4)
alias lt1="eza -lag --level=1 --icons"
alias lt2="eza -lag --level=2 --icons"
alias lt3="eza -lag --level=3 --icons"
alias l1="eza --tree --no-permissions --no-user --no-time --no-filesize --icons --level=3"
alias l2="eza --tree --no-permissions --no-user --no-time --no-filesize --icons --level=4"

# Development Tools (Gradle / Node)
alias grun="./gradlew run -q --console=plain"
alias report="open build/reports/tests/test/index.html"
alias jqinit='npm init -y && npm install --save-dev @types/jquery'

# Download best quality MP3
alias ytdl-mp3="yt-dlp -x --audio-format mp3 --audio-quality 0"

# Download best quality MP4 (Highly compatible)
alias ytdl-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

# Git Alias
alias g='git'
compdef g=git
compdef _git git-purge=git-branch

# Schedule Alias
alias schd='open /Users/callo/College/Schedule/Y2T3/image.png'

# --- 6. Custom Functions ------------------------------------------------------

# Export a percent-format .py to .ipynb  (vim's % means "current file"; in shell, pass it explicitly)
jupy() { jupytext "${1:?usage: jupy <file.py>}" --to notebook }

# Initialize a Java Gradle project
ginit() {
    local project_name=$1
    if [[ -z "$project_name" ]]; then
        echo "Usage:   ginit <project-name>"
        echo "Example: ginit helloWorld"
        return 1
    fi
    
    echo "Creating Java project with package: com.$project_name"
    gradle init --type java-application --package "$project_name"
}

# --- 7. Startup Scripts -------------------------------------------------------

# Run organizer script on macOS only. 
# Added '&!' to run in background (disowned) to prevent slow terminal startup.
if [[ "$OSTYPE" == "darwin"* ]]; then
    [[ -f "/usr/local/bin/organize-downloads.sh" ]] && /usr/local/bin/organize-downloads.sh &!
    cleanup-dsstore &!
    organize-screenshots &!
fi

export PATH=$PATH:$(go env GOPATH)/bin

# bun completions
[ -s "/Users/callo/.bun/_bun" ] && source "/Users/callo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/Users/callo/.opencode/bin:$PATH
export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"


[ -f "/Users/callo/.ghcup/env" ] && . "/Users/callo/.ghcup/env" # ghcup-env


# Added by Antigravity CLI installer
export PATH="/Users/callo/.local/bin:$PATH"
alias nb-export='f() { .venv/bin/python -m nbconvert --to notebook --execute "$1" --output "$1" && .venv/bin/jupyter nbconvert --to webpdf "$1" }; f'
nbinit() {
  local name="${1:-$(basename $PWD)}"
  uv venv .venv
  if [[ -f requirements.txt ]]; then
    uv pip install -r requirements.txt ipykernel
  else
    uv pip install ipykernel
  fi
  .venv/bin/python -m ipykernel install --user --name "$name"
  echo "✓ kernel '$name' ready — :NotebookSetKernel $name"
}

# Register an existing .venv as a Jupyter kernel (for projects already set up)
nbkernel() {
  local name="${1:-$(basename $PWD)}"
  uv pip install ipykernel
  .venv/bin/python -m ipykernel install --user --name "$name" --display-name "$name"
  echo "✓ kernel '$name' ready — :NotebookSetKernel $name"
}

# BloodDrive
alias preflight="bun run nuke"
export PATH="$HOME/.config/emacs/bin:$PATH"
alias em="emacsclient -nw"
alias emg="open -a Emacs"
