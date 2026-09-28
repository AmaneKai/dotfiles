# Install on macOS

Fresh install on macOS (Apple silicon, Homebrew under `/opt/homebrew`). Package names match `docs/packages.md`. Two interactive steps first, then one block that installs and links everything.

## 1. Interactive prerequisites

Each opens a prompt. Finish one before starting the next.

```bash
xcode-select --install
```

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Everything else

Paste the whole block. It installs every package used by zsh, tmux, ghostty, scripts and all Neovim plugins, installs the debug adapters, clones the repo to `~/Dotfiles`, moves existing dotfiles to `*.pre-stow`, stows all packages and restores the pinned plugin versions.

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install git stow zoxide eza yt-dlp gradle openjdk go bun rustup uv emacs universal-ctags node jupytext tmux fzf neovim tree-sitter-cli ripgrep fd luarocks ruff prettier eslint_d ipython delve ffmpeg bc
brew install --cask ghostty font-jetbrains-mono-nerd-font libreoffice brave-browser

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
"$(brew --prefix rustup)/bin/rustup" default stable
mkdir -p ~/.npm-global ~/.config ~/.local/bin ~/.local/share/nvim
npm config set prefix ~/.npm-global

python3 -m venv ~/.local/share/nvim/debugpy
~/.local/share/nvim/debugpy/bin/pip install debugpy
curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz | tar -xz -C ~/.local/share/nvim
curl -fsSL -o /tmp/netcoredbg.zip https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-osx-arm64.zip
unzip -oq /tmp/netcoredbg.zip -d ~/.local/share
ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg

git clone https://github.com/AmaneKai/dotfiles.git ~/Dotfiles
cd ~/Dotfiles
for file in ~/.zshrc ~/.tmux.conf ~/.gitconfig; do
    [ -e "$file" ] && [ ! -L "$file" ] && mv "$file" "$file.pre-stow"
done
stow ghostty git nvim scripts tmux zsh

nvim --headless "+Lazy! restore" +qa
exec zsh
```

Start `nvim` once afterwards. nvim-treesitter finishes building its parsers on that first interactive start.

## 3. Not installable from Homebrew

| Item | Effect |
| --- | --- |
| gdb | C, C++ and Rust debugging does not work. gdb does not run on Apple silicon |
| netcoredbg | The block installs the Apple silicon build. Intel Macs have no upstream build |
| hopes | `prefix t` in tmux opens an empty popup until `~/.cargo/bin/hopes` exists. Source unknown |
| anifetch | The `fastfetch` alias needs it. Source unknown |

## 4. Verify

| Command | Expected |
| --- | --- |
| `readlink ~/.zshrc` | `Dotfiles/zsh/.zshrc` |
| `readlink ~/.tmux.conf` | `Dotfiles/tmux/.tmux.conf` |
| `readlink ~/.local/bin/fconv` | `../../Dotfiles/scripts/.local/bin/fconv` |
| `which tmux-sessionizer` | `~/Dotfiles/bin/tmux-sessionizer` |
| `echo $SHELL` | `/bin/zsh` |
| `nvim --version \| head -1` | `NVIM v0.12.x` or newer |
| `tree-sitter --version` | `tree-sitter 0.27.x` or newer |
| `fc-list : family \| grep -c 'JetBrainsMono Nerd Font'` | a number above 0 |
| `~/.local/share/nvim/debugpy/bin/python -c "import debugpy"` | no output |
| `ls ~/.local/share/nvim/js-debug/src/dapDebugServer.js` | the file path |
| `netcoredbg --version` | a version string |
| `tmux source-file ~/.tmux.conf` | no output |
