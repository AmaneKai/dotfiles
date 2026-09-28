# Install on Arch

Fresh install on Arch or CachyOS (same package names, UNVERIFIED for CachyOS-only repos). Package names match `docs/packages.md`. Run each block in order. Skip groups for stow packages you do not use.

## 1. Base

```bash
sudo pacman -Syu --needed git stow base-devel curl tar unzip gzip
```

## 2. Extra repos

AUR. No helper assumed. `i3lock-color` replaces `i3lock` (it provides and conflicts with it). Without it the lock screen does not work.

```bash
mkdir -p ~/aur && cd ~/aur
git clone https://aur.archlinux.org/i3lock-color.git && (cd i3lock-color && makepkg -si)
git clone https://aur.archlinux.org/python-jupytext.git && (cd python-jupytext && makepkg -si)
```

Optional, ghcup from AUR instead of its installer:

```bash
cd ~/aur && git clone https://aur.archlinux.org/ghcup-hs-bin.git && (cd ghcup-hs-bin && makepkg -si)
```

## 3. Packages by group

X11 session (i3, polybar, system):

```bash
sudo pacman -S --needed xorg-server xorg-xinit xorg-xrdb xorg-xsetroot xorg-xrandr xorg-xev xf86-input-synaptics
```

Audio. Answer yes if pacman offers to remove `pulseaudio`:

```bash
sudo pacman -S --needed pipewire pipewire-pulse wireplumber libpulse
```

i3:

```bash
sudo pacman -S --needed i3-wm feh autorandr util-linux autotiling dex dunst xss-lock wezterm pcmanfm rofi networkmanager networkmanager-dmenu maim xclip brightnessctl libnotify mpv bluez bluez-utils python python-pillow python-numpy papirus-icon-theme
```

polybar:

```bash
sudo pacman -S --needed polybar psmisc procps-ng python
```

Fonts:

```bash
sudo pacman -S --needed ttf-jetbrains-mono-nerd adobe-source-han-sans-jp-fonts noto-fonts-cjk noto-fonts-emoji
```

Japanese input (not configured by the repo):

```bash
sudo pacman -S --needed fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool qt5ct
```

Power, video, hardware. Do not install `tlp` or `libva-intel-driver`:

```bash
sudo pacman -S --needed power-profiles-daemon thermald intel-media-driver libva-utils
```

zsh:

```bash
sudo pacman -S --needed zsh zoxide eza fzf yt-dlp gradle go bun deno jdk-openjdk opencode nodejs npm rustup xdg-user-dirs
```

fish:

```bash
sudo pacman -S --needed fish zoxide eza
```

tmux:

```bash
sudo pacman -S --needed tmux xclip fzf
```

nvim:

```bash
sudo pacman -S --needed neovim tree-sitter-cli ripgrep fd luarocks xclip ruff prettier eslint_d ipython nodejs npm bun gdb delve
```

scripts:

```bash
sudo pacman -S --needed ffmpeg bc libreoffice-fresh util-linux xdg-user-dirs
```

fastfetch, ghostty:

```bash
sudo pacman -S --needed fastfetch ghostty
```

## 4. Installers

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
rustup default stable
mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global
```

Debug adapters (same recipe on every distro, paths match `nvim/.config/nvim/lua/plugins/dap.lua`):

```bash
python3 -m venv ~/.local/share/nvim/debugpy
~/.local/share/nvim/debugpy/bin/pip install debugpy
mkdir -p ~/.local/share/nvim
curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz | tar -xz -C ~/.local/share/nvim
curl -fsSL https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz | tar -xz -C ~/.local/share
ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg
```

`hopes` (tmux `prefix t`): source UNVERIFIED. Must end up at `~/.cargo/bin/hopes`.

## 5. Services

```bash
sudo systemctl enable --now NetworkManager bluetooth power-profiles-daemon thermald
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## 6. Keyboard and shell

```bash
sudo localectl set-keymap jp106
sudo localectl set-x11-keymap jp jp106 "" terminate:ctrl_alt_bksp
chsh -s /usr/bin/zsh
```

## 7. Clone

`~/Dotfiles` is the default location. zsh, fish and tmux resolve the real path from the stowed symlinks.

```bash
git clone https://github.com/AmaneKai/dotfiles.git ~/Dotfiles
cd ~/Dotfiles
git checkout linux
```

## 8. Stow

Create the parent directories first so stow links files, not whole directories. Otherwise installers that write to `~/.local/bin` or `~/bin` write into the repo. Move existing shell and X start files out of the way.

```bash
mkdir -p ~/.config ~/.local/bin ~/bin
mv ~/.zshrc ~/.zshrc.pre-stow 2>/dev/null
mv ~/.xinitrc ~/.xinitrc.pre-stow 2>/dev/null
cd ~/Dotfiles
stow autorandr dunst fastfetch fish ghostty git i3 i3lock nmdmenu nvim polybar rofi scripts tmux wezterm xinit xresources zsh
```

## 9. System files

Copies `system/etc/` into `/etc` (synaptics config) and keeps numbered backups of replaced files.

```bash
~/Dotfiles/system/install.sh
```

## 10. Session start file

`~/.xinitrc` comes from the `xinit` stow package. It loads `~/.Xresources`, sets the fcitx input method variables, and starts i3 for `startx`.

## 11. Machine-specific

```bash
mkdir -p ~/Downloads/png ~/Pictures
```

Put the wallpaper at `~/Downloads/png/eclipse.png`. Follow `docs/hardware-cf-sv7.md` on the CF-SV7.

## 12. Reboot and start X

```bash
sudo reboot
```

Log in on tty1, then:

```bash
startx
```

On the CF-SV7 the `laptop` autorandr profile is already in the repo. On another machine, save your own (this overwrites the repo copy):

```bash
autorandr --save laptop
```

## 13. Verify

| Command | Expected |
| --- | --- |
| `readlink ~/.zshrc` | `Dotfiles/zsh/.zshrc` |
| `readlink ~/.xinitrc` | `Dotfiles/xinit/.xinitrc` |
| `readlink ~/.local/bin/fconv` | `../../Dotfiles/scripts/.local/bin/fconv` |
| `readlink ~/.config/i3` | `../Dotfiles/i3/.config/i3` (per-file links if `~/.config/i3` already existed) |
| `echo $SHELL` | `/usr/bin/zsh` |
| `pacman -Qo /usr/bin/i3lock` | `/usr/bin/i3lock is owned by i3lock-color ...` |
| `pactl info \| grep 'Server Name'` | `Server Name: PulseAudio (on PipeWire ...)` |
| `systemctl is-active NetworkManager bluetooth power-profiles-daemon thermald` | `active` four times |
| `pacman -Q tlp libva-intel-driver pulseaudio` | `error: package '...' was not found` for each |
| `powerprofilesctl get` | `balanced` |
| `vainfo 2>&1 \| grep -i 'driver version'` | contains `Intel iHD driver` |
| `synclient -l \| grep CircularScrolling` | `CircularScrolling = 1` |
| `ls /sys/class/power_supply` | `AC  BAT1 ...` on the CF-SV7 |
| `xrandr \| grep ' connected'` | `eDP-1 connected ...` on the CF-SV7 |
| `fc-list : family \| grep -c 'JetBrainsMono Nerd Font'` | a number above 0 |
| `pgrep -a fcitx5` | a running `fcitx5` process. Nothing in the repo starts it; `dex` starts it only if the package ships an XDG autostart file (UNVERIFIED on Arch) |
| `node --version` | `v26.x` or newer |
| `nvim --version \| head -1` | `NVIM v0.12.x` or newer |
| `tree-sitter --version` | `tree-sitter 0.26.x` or newer |
| `echo $JAVA_HOME` | the installed JDK directory under `/usr/lib/jvm` |
