# Troubleshooting

Symptom, cause, fix.

## Shell

| Symptom | Cause | Fix |
| --- | --- | --- |
| `zsh: command not found: eza` or `zoxide` | Not installed | `brew install eza zoxide`. See `docs/packages.md` |
| `tmux-sessionizer: command not found` | `~/Dotfiles/bin` not on `PATH`, or repo cloned elsewhere | `.zshrc` resolves the repo from its own symlink. Run `exec zsh` and check `echo $DOTFILES` |
| `ls` prints an eza error about `--icons` | Old alias `eza --icons` on a newer eza | Repo uses `--icons=auto`. Restow zsh if an old copy is linked |
| `git purge` only deletes the local branch | A `purge` git alias shadows the `git-purge` script | Remove the alias from `~/.gitconfig`. The repo config has none |
| Files in `~/Downloads` move on every new shell | `.zshrc` runs `organize-downloads` on macOS | Expected behavior of the config |
| `~/Pictures` top-level files move into `other/` | `organize-screenshots` sorts everything left at the top level | Expected behavior of the config |
| `anifetch: command not found` when running `fastfetch` | The `fastfetch` alias runs `anifetch` with a relative path | Run it from a directory containing `anifetch/`, or remove the alias |

## tmux

| Symptom | Cause | Fix |
| --- | --- | --- |
| Selection does not reach the macOS clipboard | Older config piped to `xclip` | Restow tmux. The config pipes to `pbcopy` |
| `prefix t` popup closes at once | `~/.cargo/bin/hopes` missing | Install hopes (source UNVERIFIED) |
| `prefix f` or the jump keys do nothing | `$DOTFILES` unset in tmux | `tmux source-file ~/.tmux.conf`. The config sets it from the `~/.tmux.conf` symlink |
| `prefix L` opens nothing | `~/LBYARCH` does not exist | Create it or remove the binding |

## Neovim

| Symptom | Cause | Fix |
| --- | --- | --- |
| lazy.nvim errors on plenary or rockspec | luarocks missing | `brew install luarocks`, or set `rocks = { enabled = false }` in `lazy.setup` |
| nvim-treesitter fails to build parsers | Neovim below 0.12, tree-sitter-cli below 0.26.1, or no C compiler | `brew upgrade neovim tree-sitter-cli`, `xcode-select --install` |
| `<leader>f` formats nothing | Formatter missing (ruff, prettier, eslint_d) | Install per `docs/packages.md` |
| No completion or hover from a language server | No LSP is configured on this branch | Expected. Completion covers path, snippets and buffer |
| `<leader>cc` says no configuration for the filetype | No adapter defined for that language | Supported: C, C++, Rust, Python, Go, JS, TS, C#. See `docs/neovim.md` |
| Debug session starts and exits at once | Adapter not installed or not at the expected path | Check `dlv version`, `netcoredbg --version`, `ls ~/.local/share/nvim/js-debug/src/dapDebugServer.js`, `~/.local/share/nvim/debugpy/bin/python -c "import debugpy"` |
| C, C++ or Rust debugging cannot start | `gdb` does not run on Apple silicon | No fix in the repo. lldb is not configured |
| C, C++ or Rust breakpoints never hit | Binary built without debug info | Build with `-g` (C, C++) or a debug profile (`cargo build`) |
| md-peek fails to open | Server dependencies missing | `cd ~/.local/share/nvim/lazy/md-peek.nvim/server && npm install` |
| ipynb-peek fails to open | Server dependencies missing | `cd ~/.local/share/nvim/lazy/ipynb-peek.nvim/server && bun install` |
| markdown-preview build fails | yarn install through `npx` failed | `cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npx --yes yarn install` |
| Notebook kernel not found | No kernel for the project `.venv` | `nbkernel` in the project directory |
| live-server build fails | `npm install -g` needs a writable prefix | `npm config set prefix ~/.npm-global` |
| Typst preview does not start | typst-preview.nvim binaries not downloaded | `:lua require("typst-preview").update()`, then `<leader>ty` |

## Stow

| Symptom | Cause | Fix |
| --- | --- | --- |
| `existing target is neither a link nor a directory` | Real file at the target | Move the file away, then stow |
| Conflict on a dangling symlink | Old link to a moved or deleted repo | Remove the link, then stow |
| Links broken after moving or renaming the repo | Links are relative to the old path | `stow -D <pkgs>` first, then move, then `stow <pkgs>` |
| Editing a stowed file with `sed -i ''` replaced the link | `sed -i` writes a new file | Edit through the repo path, not the link |
| New files show up inside the repo | Stow folded a whole directory (for example `~/.local/bin`) into a link | `stow -D <pkg>`, move non-repo files out, `mkdir -p` the real directory, stow again |
| `.DS_Store` files show in `git status` | Finder | Already in `.gitignore`. `cleanup-dsstore` deletes them under `$HOME` |
