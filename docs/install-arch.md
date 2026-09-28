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
sudo pacman -S --needed xorg-server xorg-xinit xorg-xrdb xorg-xsetroot xorg-xrandr xf86-input-synaptics
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
sudo pacman -S --needed power-profiles-daemon thermald acpid intel-media-driver libva-utils
```

zsh:

```bash
sudo pacman -S --needed zsh zoxide eza fzf yt-dlp gradle go bun jdk-openjdk opencode nodejs npm rustup xdg-user-dirs
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
sudo pacman -S --needed neovim tree-sitter-cli ripgrep fd luarocks xclip ruff prettier eslint_d ipython nodejs npm jdk-openjdk bun
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
curl -fsSL https://deno.land/install.sh | sh
rustup default stable
rustup component add clippy
mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global
```

Accept the deno installer's offer to edit shell config. `zsh/.zshrc:98` needs `~/.deno/env` (UNVERIFIED that the installer creates it otherwise).

`hopes` (tmux `prefix t`): source UNVERIFIED. Must end up at `~/.cargo/bin/hopes`.

## 5. Services

```bash
sudo systemctl enable --now NetworkManager bluetooth power-profiles-daemon thermald acpid
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## 6. Keyboard and shell

```bash
sudo localectl set-keymap jp106
sudo localectl set-x11-keymap jp jp106 "" terminate:ctrl_alt_bksp
chsh -s /usr/bin/zsh
```

## 7. Clone

The repo must be at `~/Dotfiles` (hardcoded in zsh, fish, tmux).

```bash
git clone https://github.com/AmaneKai/dotfiles.git ~/Dotfiles
cd ~/Dotfiles
git checkout linux
```

## 8. Stow

Create the parent directories first so stow links files, not whole directories. Otherwise tools that write to `~/.local/bin` write into the repo.

```bash
mkdir -p ~/.config ~/.local/bin
mv ~/.zshrc ~/.zshrc.pre-stow 2>/dev/null
cd ~/Dotfiles
stow --ignore=g14-power --ignore=claude autorandr dunst fastfetch fish ghostty git i3 i3lock nmdmenu nvim polybar rofi scripts tmux wezterm xresources zsh
```

## 9. System files

Copies `system/etc/` into `/etc` (synaptics config). The acpi part does nothing until `system/etc/acpi/` exists (see `docs/known-issues.md`).

```bash
~/Dotfiles/system/install.sh
```

## 10. Session start file

Not in repo. i3 runs from `startx`.

```bash
cat > ~/.xinitrc <<'EOF'
#!/bin/sh
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
export GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx SDL_IM_MODULE=fcitx
exec i3
EOF
```

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

After the first X start, save the autorandr profile used by i3:

```bash
autorandr --save laptop
```

## 13. Verify

| Command | Expected |
| --- | --- |
| `readlink ~/.zshrc` | `Dotfiles/zsh/.zshrc` |
| `readlink ~/.config/i3` | `../Dotfiles/i3/.config/i3` (per-file links if `~/.config/i3` already existed) |
| `echo $SHELL` | `/usr/bin/zsh` |
| `pacman -Qo /usr/bin/i3lock` | `/usr/bin/i3lock is owned by i3lock-color ...` |
| `pactl info \| grep 'Server Name'` | `Server Name: PulseAudio (on PipeWire ...)` |
| `systemctl is-active NetworkManager bluetooth power-profiles-daemon thermald acpid` | `active` five times |
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
| `ls /usr/lib/jvm` | `java-27-openjdk`. Compare with `JAVA_HOME` in `zsh/.zshrc:94` (hardcoded `java-26-openjdk`) |
