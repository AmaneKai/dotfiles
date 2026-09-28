# Install on Fedora

Fresh install on Fedora 44, KDE or Workstation edition. Log into the i3 X11 session at the end. Package names match `docs/packages.md`. Run each block in order. Skip groups for stow packages you do not use.

## 1. Base

```bash
sudo dnf upgrade --refresh -y
sudo dnf install -y git stow gcc make curl tar unzip gzip
```

## 2. Extra repos

RPM Fusion (needed for full ffmpeg and the nonfree Intel media driver):

```bash
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

COPR (wezterm, ghostty):

```bash
sudo dnf copr enable -y wezfurlong/wezterm-nightly
sudo dnf copr enable -y scottames/ghostty
```

## 3. Packages by group

X11 session (i3, polybar, system):

```bash
sudo dnf install -y xorg-x11-server-Xorg xorg-x11-xinit xrdb xsetroot xrandr xev xorg-x11-drv-synaptics-legacy
```

KDE X11 session (optional, only to keep Plasma on X11). If dnf reports a file conflict with `kmime`, remove the old `kmime` package first:

```bash
sudo dnf install -y plasma-workspace-x11
```

Audio. Do not install `pulseaudio`:

```bash
sudo dnf install -y pipewire pipewire-pulseaudio wireplumber pulseaudio-utils
```

i3:

```bash
sudo dnf install -y i3 feh autorandr util-linux dex-autostart dunst xss-lock wezterm pcmanfm rofi NetworkManager maim xclip brightnessctl libnotify mpv bluez python3 python3-pillow python3-numpy papirus-icon-theme python3-gobject NetworkManager-libnm pipx
pipx install autotiling
sudo curl -fsSL -o /usr/local/bin/networkmanager_dmenu https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu
sudo chmod +x /usr/local/bin/networkmanager_dmenu
```

i3lock (i3lock-color, needed by `lock.sh`). Not in Fedora. Several COPRs exist (`lxdes/i3lock-color`, `tokariew/i3lock-color`, others), none verified. Build from source:

```bash
git clone https://github.com/Raymo111/i3lock-color.git ~/src/i3lock-color
cd ~/src/i3lock-color
./install-i3lock-color.sh
```

Build dependencies for Fedora: see the i3lock-color README (UNVERIFIED).

polybar:

```bash
sudo dnf install -y polybar psmisc procps-ng python3
```

Fonts:

```bash
sudo dnf install -y adobe-source-han-sans-jp-fonts google-noto-sans-cjk-fonts google-noto-color-emoji-fonts
mkdir -p ~/.local/share/fonts/JetBrainsMono
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts/JetBrainsMono
fc-cache -f
```

Japanese input (not configured by the repo):

```bash
sudo dnf install -y fcitx5 fcitx5-autostart fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool qt5ct
```

Power, video, hardware. Do not install `tlp`. If `tuned-ppd` is installed it conflicts with power-profiles-daemon; which one Fedora KDE 44 ships by default is UNVERIFIED:

```bash
rpm -q tuned-ppd && sudo dnf swap -y tuned-ppd power-profiles-daemon
sudo dnf install -y power-profiles-daemon thermald libva-utils
sudo dnf install -y intel-media-driver
```

`intel-media-driver` comes from RPM Fusion nonfree. If dnf reports a conflict with `libva-intel-media-driver`, run `sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing` (UNVERIFIED).

zsh:

```bash
sudo dnf install -y zsh zoxide eza fzf yt-dlp golang java-latest-openjdk-devel nodejs24 nodejs24-bin nodejs24-npm nodejs24-npm-bin rustup xdg-user-dirs
```

fish:

```bash
sudo dnf install -y fish zoxide eza
```

tmux:

```bash
sudo dnf install -y tmux xclip fzf
```

nvim:

```bash
sudo dnf install -y neovim tree-sitter-cli ripgrep fd-find luarocks xclip ruff python3-ipython python3-jupytext gdb delve nodejs24 nodejs24-bin nodejs24-npm nodejs24-npm-bin
```

scripts:

```bash
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf install -y ffmpeg bc libreoffice util-linux xdg-user-dirs
```

fastfetch, ghostty:

```bash
sudo dnf install -y fastfetch ghostty
```

## 4. Installers

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
curl -fsSL https://deno.land/install.sh | sh
curl -fsSL https://bun.sh/install | bash
curl -fsSL https://opencode.ai/install | bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
rustup-init -y
~/.cargo/bin/mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global
npm install -g prettier eslint_d
```

gradle: not in Fedora. Download from https://services.gradle.org/distributions/ or use SDKMAN (UNVERIFIED).

Rose Pine GTK theme and cursor (not packaged):

```bash
mkdir -p ~/.themes ~/.icons
curl -fsSL https://github.com/rose-pine/gtk/releases/download/v2.2.0/gtk3.tar.gz | tar -xz --strip-components=1 -C ~/.themes gtk3/rose-pine-gtk
curl -fsSL https://github.com/rose-pine/cursor/releases/download/v1.1.0/BreezeX-RosePine-Linux.tar.xz | tar -xJ -C ~/.icons
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
mkdir -p ~/.config ~/.config/gtk-3.0 ~/.config/gtk-4.0 ~/.local/bin ~/bin ~/.icons
mv ~/.zshrc ~/.zshrc.pre-stow 2>/dev/null
mv ~/.xinitrc ~/.xinitrc.pre-stow 2>/dev/null
cd ~/Dotfiles
stow autorandr dunst fastfetch fish ghostty git gtk i3 i3lock nmdmenu nvim picom polybar rofi scripts tmux wezterm xinit xresources zsh
```

## 9. System files

Copies `system/etc/` into `/etc` (synaptics config) and keeps numbered backups of replaced files.

```bash
~/Dotfiles/system/install.sh
```

## 10. Session start file

`~/.xinitrc` comes from the `xinit` stow package. It loads `~/.Xresources`, sets the fcitx input method variables, and starts i3 for `startx`. With a display manager (SDDM), pick the i3 session instead; `~/.xinitrc` is then not read and the input method variables must be set another way (UNVERIFIED which file the display manager reads).

## 11. Machine-specific

```bash
mkdir -p ~/Downloads/png ~/Pictures
```

Put the wallpaper at `~/Downloads/png/eclipse.png`. Follow `docs/hardware-cf-sv7.md` on the CF-SV7.

KDE only: stop the Baloo indexer.

```bash
balooctl6 disable
```

## 12. Reboot and start X

```bash
sudo reboot
```

Log into the i3 session, or on a tty run `startx`. On the CF-SV7 the `laptop` autorandr profile is already in the repo. On another machine, save your own (this overwrites the repo copy):

```bash
autorandr --save laptop
```

## 13. Verify

| Command | Expected |
| --- | --- |
| `readlink ~/.zshrc` | `Dotfiles/zsh/.zshrc` |
| `readlink ~/.xinitrc` | `Dotfiles/xinit/.xinitrc` |
| `readlink ~/.config/gtk-3.0/settings.ini` | `../../Dotfiles/gtk/.config/gtk-3.0/settings.ini` |
| `readlink ~/.local/bin/fconv` | `../../Dotfiles/scripts/.local/bin/fconv` |
| `readlink ~/.config/i3` | `../Dotfiles/i3/.config/i3` (per-file links if `~/.config/i3` already existed) |
| `echo $SHELL` | `/usr/bin/zsh` |
| `i3lock --help 2>&1 \| grep -c -- --clock` | a number above 0 (i3lock-color). Output format UNVERIFIED |
| `pactl info \| grep 'Server Name'` | `Server Name: PulseAudio (on PipeWire ...)` |
| `systemctl is-active NetworkManager bluetooth power-profiles-daemon thermald` | `active` four times |
| `rpm -q tlp tuned-ppd pulseaudio` | `package ... is not installed` for each |
| `powerprofilesctl get` | `balanced` |
| `vainfo 2>&1 \| grep -i 'driver version'` | contains `Intel iHD driver` |
| `synclient -l \| grep CircularScrolling` | `CircularScrolling = 1` |
| `ls /sys/class/power_supply` | `AC  BAT1 ...` on the CF-SV7 |
| `xrandr \| grep ' connected'` | `eDP-1 connected ...` on the CF-SV7 |
| `fc-list : family \| grep -c 'JetBrainsMono Nerd Font'` | a number above 0 |
| `pgrep -a fcitx5` | a running `fcitx5` process. Started by `dex` from the `fcitx5-autostart` package |
| `node --version` | `v24.x` |
| `nvim --version \| head -1` | `NVIM v0.12.x` or newer |
| `tree-sitter --version` | `tree-sitter 0.26.x` or newer |
| `echo $JAVA_HOME` | the installed JDK directory under `/usr/lib/jvm` |
