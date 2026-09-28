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
export BUN_INSTALL="$HOME/.bun"

typeset -U path
path=(
    "$DOTFILES/bin"
    "$HOME/.local/bin"
    "$HOME/Library/Python/3.14/bin"
    "$HOME/.local/share/nvim/mason/bin"
    "$HOME/.npm-global/bin"
    "$BUN_INSTALL/bin"
    "$HOME/.opencode/bin"
    "$HOME/.config/emacs/bin"
    "/opt/homebrew/opt/openjdk/bin"
    "/opt/homebrew/opt/ffmpeg-full/bin"
    "/usr/local/mysql/bin"
    $path
)

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
command -v go &>/dev/null && path+=("$(go env GOPATH)/bin")
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

bindkey -s '^f' 'tmux-sessionizer\n'

alias vi="nvim"
alias ctags="/opt/homebrew/bin/ctags"
alias fastfetch="anifetch anifetch/src/anifetch/assets/badapple.mp4"

_eza="eza --icons=auto"
_eza_bare="$_eza --tree --no-permissions --no-user --no-time --no-filesize"
alias ls="$_eza"
alias ll="$_eza -lg"
alias la="$_eza -lag"
alias lt="$_eza -lag"
alias lt1="$_eza -lag --level=1"
alias lt2="$_eza -lag --level=2"
alias lt3="$_eza -lag --level=3"
alias l="$_eza --tree --git-ignore --level=5 --group-directories-first"
alias lw="$_eza_bare --git-ignore --level=5"
alias l1="$_eza_bare --level=3"
alias l2="$_eza_bare --level=4"

alias grun="./gradlew run -q --console=plain"
alias report="open build/reports/tests/test/index.html"
alias jqinit='npm init -y && npm install --save-dev @types/jquery'

alias ytdl-mp3="yt-dlp -x --audio-format mp3 --audio-quality 0"
alias ytdl-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

alias g='git'
compdef g=git
zstyle ':completion:*:*:git:*' user-commands purge:'delete a branch locally and on its remote'
_git-purge() {
    _arguments '1:branch:__git_branch_names' '2:remote:__git_remotes'
}

alias schd='open "$HOME/College/Schedule/Y2T3/image.png"'
alias em="emacsclient -nw"
alias emg="open -a Emacs"
alias nb-export='f() { .venv/bin/python -m nbconvert --to notebook --execute "$1" --output "$1" && .venv/bin/jupyter nbconvert --to webpdf "$1" }; f'

jupy() { jupytext "${1:?usage: jupy <file.py>}" --to notebook }

ginit() {
    local project_name=$1
    if [[ -z "$project_name" ]]; then
        echo "Usage: ginit <project-name>"; return 1
    fi
    gradle init --type java-application --package "$project_name"
}

nbkernel() {
    local name="${1:-$(basename $PWD)}"
    uv pip install ipykernel
    .venv/bin/python -m ipykernel install --user --name "$name" --display-name "$name"
    echo "✓ kernel '$name' ready — :NotebookSetKernel $name"
}

nbinit() {
    local name="${1:-$(basename $PWD)}"
    uv venv .venv
    if [[ -f requirements.txt ]]; then
        uv pip install -r requirements.txt ipykernel
    else
        uv pip install ipykernel
    fi
    nbkernel "$name"
}

if [[ "$OSTYPE" == darwin* ]]; then
    organize-downloads &!
    cleanup-dsstore &!
    organize-screenshots &!
fi
