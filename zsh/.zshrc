zshrc_path="${(%):-%x}"
DOTFILES="${zshrc_path:A:h:h}"
[[ -d "$DOTFILES/bin" ]] || DOTFILES="$HOME/Dotfiles"
unset zshrc_path
export DOTFILES

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
else
    autoload -Uz compinit && compinit
fi

export EDITOR="nvim"
export VISUAL="nvim"
export QT_QPA_PLATFORMTHEME="qt5ct"

export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export vblank_mode=0

typeset -U path
path=(
    "$HOME/.cargo/bin"
    "$DOTFILES/bin"
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.bun/bin"
    "$HOME/.ghcup/bin"
    "$HOME/.deno/bin"
    "$HOME/.opencode/bin"
    "/usr/bin"
    $path
)

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

bindkey -s '^f' 'tmux-sessionizer\n'

alias vi="nvim"

alias ls="eza --icons=auto"
alias ll="eza -lg --icons=auto"
alias la="eza -lag --icons=auto"
alias l="eza --tree --git-ignore --icons=auto --level=3 --group-directories-first"

alias grun="./gradlew run -q --console=plain"
alias jqinit='npm init -y && npm install --save-dev @types/jquery'

alias ytdl-mp3="yt-dlp -x --audio-format mp3 --audio-quality 0"
alias ytdl-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

alias g='git'
compdef g=git

zstyle ':completion:*:*:git:*' user-commands purge:'delete a branch locally and on its remote'
_git-purge() {
    _arguments '1:branch:__git_branch_names' '2:remote:__git_remotes'
}

ginit() {
    local project_name=$1
    if [[ -z "$project_name" ]]; then
        echo "Usage: ginit <project-name>"; return 1
    fi
    gradle init --type java-application --package "$project_name"
}

if command -v go &>/dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
fi

export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

alias preflight="bunx prisma generate && bun run check && bun run test && bun run build"

if command -v java &>/dev/null; then
    export JAVA_HOME="${$(readlink -f "$(command -v java)"):h:h}"
fi

[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

[[ -x "$HOME/.local/bin/organize-downloads" ]] && "$HOME/.local/bin/organize-downloads" --quiet
