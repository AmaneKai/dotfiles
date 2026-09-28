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
| gtk | GTK 2/3/4 theme, icons, cursor | `~/.config/gtk-3.0/`, `~/.config/gtk-4.0/`, `~/.gtkrc-2.0`, `~/.icons/default/` |
| i3 | window manager, audio, bluetooth and power menus, OSD, lock image generator | `~/.config/i3/` |
| i3lock | lock screen script | `~/bin/lock.sh` |
| nmdmenu | networkmanager-dmenu | `~/.config/networkmanager-dmenu/config.ini` |
| nvim | Neovim | `~/.config/nvim/` |
| picom | compositor: vsync, shadows, fades | `~/.config/picom/picom.conf` |
| polybar | status bar | `~/.config/polybar/` |
| rofi | launcher theme | `~/.config/rofi/` |
| scripts | fconv, git-purge, organize-downloads, organize-screenshots, cleanup-dsstore | `~/.local/bin/` |
| tmux | tmux | `~/.tmux.conf` |
| wezterm | wezterm terminal (i3 default) | `~/.config/wezterm/wezterm.lua` |
| xinit | `startx` session: Xresources, input method variables, i3 | `~/.xinitrc` |
| xresources | Xft DPI | `~/.Xresources` |
| zsh | zsh with oh-my-zsh (login shell) | `~/.zshrc` |

Not stowed: `bin/` (added to PATH by zsh and fish), `system/` (copied to `/etc` by `system/install.sh`), `extras/` (tools for other machines), `discord/` (copy by hand).

## Quick start

1. Install packages for your distro: [Arch](docs/install-arch.md), [Fedora](docs/install-fedora.md), [Debian family](docs/install-debian.md).
2. Clone and check out `linux`. `~/Dotfiles` is the default location; zsh, fish and tmux resolve the real path from the symlinks.
3. Run `mkdir -p ~/.config ~/.config/gtk-3.0 ~/.config/gtk-4.0 ~/.local/bin ~/bin ~/.icons`.
4. From `~/Dotfiles`, run `stow <packages>`.
5. Run `~/Dotfiles/system/install.sh`.
6. Reboot and run `startx`.
7. Run the verify table at the end of the install guide.

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
