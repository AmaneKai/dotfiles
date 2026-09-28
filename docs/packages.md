# Packages

Single source of truth for Homebrew names. `docs/install-macos.md` must match this file.

Verified 2026-09-29 against the Homebrew API (`brew info --json=v2`) on Homebrew 7.0.6. Formulae are installed with `brew install`, casks with `brew install --cask`.

Legend:

| Mark | Meaning |
| --- | --- |
| formula | `brew install <name>` |
| cask | `brew install --cask <name>` |
| `manual` | Not in Homebrew. See the Manual installs table |
| UNVERIFIED | Behavior not confirmed |

## Base

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| git | lazy.nvim bootstrap, clone | `nvim/.config/nvim/lua/callo/lazy.lua` | formula | git |
| stow | install | all packages | formula | stow |
| Xcode command line tools | C compiler for treesitter parsers | `nvim/.config/nvim/lua/plugins/treesitter.lua` | manual | `xcode-select --install` |

## zsh

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| oh-my-zsh | framework | `zsh/.zshrc` | manual | see Manual installs |
| zoxide | `zoxide init` | `zsh/.zshrc` | formula | zoxide |
| eza | `ls`, `ll`, `la`, `l` aliases | `zsh/.zshrc` | formula | eza |
| yt-dlp | `ytdl-mp3`, `ytdl-mp4` | `zsh/.zshrc` | formula | yt-dlp |
| gradle | `ginit` | `zsh/.zshrc` | formula | gradle |
| openjdk | Java, on PATH from `/opt/homebrew/opt/openjdk/bin` | `zsh/.zshrc` | formula | openjdk |
| go | `GOPATH/bin` on PATH | `zsh/.zshrc` | formula | go |
| bun | PATH, completions | `zsh/.zshrc` | formula | bun |
| rustup | `~/.cargo/env` | `zsh/.zshrc` | formula | rustup |
| uv | `nbinit`, `nbkernel` | `zsh/.zshrc` | formula | uv |
| emacs | `em`, `emg` | `zsh/.zshrc` | formula | emacs |
| ctags | `ctags` alias to `/opt/homebrew/bin/ctags` | `zsh/.zshrc` | formula | universal-ctags |
| node, npm | `~/.npm-global/bin` on PATH, live-server, md-peek | `zsh/.zshrc` | formula | node |
| jupytext | `jupy` | `zsh/.zshrc` | formula | jupytext |

## tmux

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| tmux | multiplexer | `tmux/.tmux.conf` | formula | tmux |
| fzf | tmux-sessionizer picker | `bin/tmux-sessionizer` | formula | fzf |
| hopes | `prefix t` popup | `tmux/.tmux.conf` | manual | `~/.cargo/bin/hopes`, source UNVERIFIED |

`pbcopy` ships with macOS.

## ghostty

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| Ghostty | terminal | `ghostty/.config/ghostty/config` | cask | ghostty |
| JetBrains Mono Nerd Font | `font-family`, eza icons | `ghostty/.config/ghostty/config` | cask | font-jetbrains-mono-nerd-font |

## nvim

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| Neovim 0.12+ | editor, nvim-treesitter `main` | `nvim/.config/nvim` | formula | neovim |
| tree-sitter-cli | nvim-treesitter `main` parser builds | `lua/plugins/treesitter.lua` | formula | tree-sitter-cli |
| ripgrep | telescope live grep | `lua/plugins/telescope.lua` | formula | ripgrep |
| fd | telescope find files | `lua/plugins/telescope.lua` | formula | fd |
| luarocks | lazy.nvim rockspecs | `lua/callo/lazy.lua` | formula | luarocks |
| ruff | `ruff_format` | `lua/plugins/conform.lua` | formula | ruff |
| prettier | JSON, CSS, HTML, Markdown, Svelte formatting | `lua/plugins/conform.lua` | formula | prettier |
| eslint_d | JS, TS, Svelte formatting | `lua/plugins/conform.lua` | formula | eslint_d |
| ipython | iron.nvim REPL | `lua/plugins/python.lua` | formula | ipython |
| jupytext | `.ipynb` as `.py` | `lua/plugins/python.lua` | formula | jupytext |
| bun | ipynb-peek server | `lua/plugins/ipynb-peek.lua` | formula | bun |
| node, npm | markdown-preview, md-peek, live-server, js-debug | `lua/plugins/markdown.lua`, `md-peek.lua`, `liveserver.lua`, `dap.lua` | formula | node |
| Brave | live-server opens `brave browser` | `lua/plugins/liveserver.lua` | cask | brave-browser |
| gdb | C, C++, Rust debugging | `lua/plugins/dap.lua` | formula | gdb, does not run on Apple silicon, UNVERIFIED on Intel |
| delve | Go debugging | `lua/plugins/dap.lua` | formula | delve |
| debugpy | Python debugging | `lua/plugins/dap.lua` | manual | see Manual installs |
| js-debug | JavaScript, TypeScript debugging | `lua/plugins/dap.lua` | manual | see Manual installs |
| netcoredbg | C# debugging | `lua/plugins/dap.lua` | manual | see Manual installs |

No LSP is configured. typst-preview.nvim downloads its own binaries (`lua/plugins/typst.lua`). Debug adapter paths in `dap.lua` match the Manual installs recipes.

## scripts

| Tool | Used by | Where | Kind | Name |
| --- | --- | --- | --- | --- |
| ffmpeg, ffprobe | fconv | `scripts/.local/bin/fconv` | formula | ffmpeg |
| bc | fconv Discord mode | `scripts/.local/bin/fconv` | formula | bc |
| LibreOffice | fconv documents | `scripts/.local/bin/fconv` | cask | libreoffice |

`git-purge`, `organize-downloads`, `organize-screenshots` and `cleanup-dsstore` use only macOS tools.

## Manual installs

| Tool | Command |
| --- | --- |
| Homebrew | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| oh-my-zsh | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc` |
| Rust toolchain | `rustup default stable` after `brew install rustup` |
| npm global prefix | `mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global` |
| debugpy | `python3 -m venv ~/.local/share/nvim/debugpy && ~/.local/share/nvim/debugpy/bin/pip install debugpy` |
| js-debug | `mkdir -p ~/.local/share/nvim && curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz \| tar -xz -C ~/.local/share/nvim` (creates `js-debug/`) |
| netcoredbg | `curl -fsSL -o /tmp/netcoredbg.zip https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-osx-arm64.zip && unzip -oq /tmp/netcoredbg.zip -d ~/.local/share && ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg` (Apple silicon only) |
