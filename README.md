# Dotfiles

i3 (X11) desktop, shell, and editor configs for Arch, Fedora, and the Debian family (Debian, Ubuntu, Mint), managed with GNU stow.

## Stow packages

| Package | Configures | Target |
| --- | --- | --- |
| autorandr | polybar relaunch on display change | `~/.config/autorandr/postswitch.d/polybar` |
| dunst | notifications | `~/.config/dunst/dunstrc` |
| fastfetch | system info | `~/.config/fastfetch/` |
| fish | fish shell | `~/.config/fish/config.fish` |
| ghostty | ghostty terminal | `~/.config/ghostty/config` |
| git | git user and aliases | `~/.gitconfig` |
| i3 | window manager, audio and bluetooth menus, lock image generator | `~/.config/i3/` |
| i3lock | lock screen script | `~/bin/lock.sh` |
| nmdmenu | networkmanager-dmenu | `~/.config/networkmanager-dmenu/config.ini` |
| nvim | Neovim | `~/.config/nvim/` |
| polybar | status bar | `~/.config/polybar/` |
| rofi | launcher theme | `~/.config/rofi/` |
| scripts | fconv, git-purge, organize-downloads, organize-screenshots, cleanup-dsstore, uv | `~/.local/bin/` |
| tmux | tmux | `~/.tmux.conf` |
| wezterm | wezterm terminal (i3 default) | `~/.config/wezterm/wezterm.lua` |
| xresources | Xft DPI | `~/.Xresources` |
| zsh | zsh with oh-my-zsh (login shell) | `~/.zshrc` |

Not stowed: `bin/` (used in place from `~/Dotfiles/bin`), `system/` (copied to `/etc` by `system/install.sh`), `discord/` (copy by hand).

## Quick start

1. Install packages for your distro: [Arch](docs/install-arch.md), [Fedora](docs/install-fedora.md), [Debian family](docs/install-debian.md).
2. Clone to `~/Dotfiles` and check out `linux`.
3. Run `mkdir -p ~/.config ~/.local/bin`.
4. From `~/Dotfiles`, run `stow --ignore=g14-power --ignore=claude <packages>`.
5. Run `~/Dotfiles/system/install.sh`.
6. Create `~/.xinitrc` as shown in the install guide.
7. Reboot, run `startx`, then `autorandr --save laptop`.
8. Run the verify table at the end of the install guide.

## Docs

| File | Content |
| --- | --- |
| [docs/packages.md](docs/packages.md) | tool to package matrix, single source of truth |
| [docs/install-arch.md](docs/install-arch.md) | fresh install on Arch, CachyOS |
| [docs/install-fedora.md](docs/install-fedora.md) | fresh install on Fedora |
| [docs/install-debian.md](docs/install-debian.md) | fresh install on Debian, Ubuntu, Mint |
| [docs/hardware-cf-sv7.md](docs/hardware-cf-sv7.md) | CF-SV7 touchpad, F-keys, Bluetooth, power |
| [docs/neovim.md](docs/neovim.md) | Neovim plugins, languages, keymaps |
| [docs/fconv.md](docs/fconv.md) | fconv converter usage |
| [docs/troubleshooting.md](docs/troubleshooting.md) | symptom, cause, fix |
| [docs/known-issues.md](docs/known-issues.md) | bugs and hardcoded values in configs |
