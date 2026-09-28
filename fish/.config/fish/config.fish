set -g fish_greeting

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx MESA_GL_VERSION_OVERRIDE 4.5
set -gx MESA_GLSL_VERSION_OVERRIDE 450
set -gx vblank_mode 0
set -gx BUN_INSTALL $HOME/.bun

set -l dotfiles (path resolve (status filename) | path dirname | path dirname | path dirname | path dirname)
test -d $dotfiles/bin; or set dotfiles $HOME/Dotfiles
set -gx DOTFILES $dotfiles

fish_add_path -g \
    $HOME/.cargo/bin \
    $DOTFILES/bin \
    $HOME/.local/bin \
    $HOME/.local/share/nvim/mason/bin \
    $HOME/.npm-global/bin \
    $HOME/.bun/bin \
    $HOME/.ghcup/bin \
    $HOME/.deno/bin \
    $HOME/.opencode/bin

if type -q go
    fish_add_path -g -a (go env GOPATH)/bin
end

if type -q java
    set -gx JAVA_HOME (path resolve (command -v java) | path dirname | path dirname)
end

alias vi nvim
alias ls "eza --icons=auto"
alias ll "eza -lg --icons=auto"
alias la "eza -lag --icons=auto"
alias l "eza --tree --git-ignore --icons=auto --level=3 --group-directories-first"
alias grun "./gradlew run -q --console=plain"
alias jqinit "npm init -y && npm install --save-dev @types/jquery"
alias ytdl-mp3 "yt-dlp -x --audio-format mp3 --audio-quality 0"
alias ytdl-mp4 "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"
alias preflight "bunx prisma generate && bun run check && bun run test && bun run build"
alias g git
complete -c g -w git

function ginit
    if test (count $argv) -eq 0
        echo "Usage: ginit <project-name>"
        return 1
    end
    gradle init --type java-application --package $argv[1]
end

if status is-interactive
    if type -q zoxide
        zoxide init fish | source
    end

    bind \cf 'tmux-sessionizer; commandline -f repaint'

    if test -x $HOME/.local/bin/organize-downloads
        $HOME/.local/bin/organize-downloads --quiet
    end
end
