# Dotfiles

Shell, terminal and editor configs for macOS, managed with GNU stow. The Linux setup lives on the `linux` branch. The two branches never merge.

## Stow packages

| Package | Configures | Target |
| --- | --- | --- |
| ghostty | ghostty terminal | `~/.config/ghostty/config` |
| git | git user and aliases | `~/.gitconfig` |
| nvim | Neovim | `~/.config/nvim/` |
| scripts | fconv, git-purge, organize-downloads, organize-screenshots, cleanup-dsstore | `~/.local/bin/` |
| tmux | tmux | `~/.tmux.conf` |
| zsh | zsh with oh-my-zsh | `~/.zshrc` |

Not stowed: `bin/` (added to `PATH` by zsh), `discord/` (copy by hand).

## Quick start

1. Install packages: [docs/install-macos.md](docs/install-macos.md).
2. Clone to `~/Dotfiles`. zsh and tmux resolve the real path from the symlinks.
3. Run `mkdir -p ~/.config ~/.local/bin`.
4. From `~/Dotfiles`, run `stow ghostty git nvim scripts tmux zsh`.
5. Run `exec zsh`, then start `nvim` once so lazy.nvim installs plugins.
6. Run the verify table at the end of the install guide.

## Docs

| File | Content |
| --- | --- |
| [docs/packages.md](docs/packages.md) | tool to Homebrew name matrix, single source of truth |
| [docs/install-macos.md](docs/install-macos.md) | fresh install on macOS |
| [docs/neovim.md](docs/neovim.md) | Neovim plugins, languages, keymaps |
| [docs/fconv.md](docs/fconv.md) | fconv converter usage |
| [docs/troubleshooting.md](docs/troubleshooting.md) | symptom, cause, fix |
| [docs/known-issues.md](docs/known-issues.md) | bugs and hardcoded values in configs |
