# Install on Debian family

Fresh install on Debian 13 trixie, Ubuntu 24.04 noble, or Linux Mint 22 (uses the noble lines). Package names match `docs/packages.md`. Run each block in order. Skip groups for stow packages you do not use. Where a block differs, it is labeled trixie or noble/Mint.

## 1. Base

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y git stow build-essential curl tar unzip gzip xz-utils
```

## 2. Extra repos

wezterm apt repo (from wezterm's install docs):

```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
```

Optional, for `intel-media-va-driver-non-free`: enable the `non-free` component (Debian) or `multiverse` (Ubuntu, Mint) in your apt sources.

## 3. Packages by group

X11 session (i3, polybar, system):

```bash
sudo apt install -y xserver-xorg xinit x11-xserver-utils x11-utils xserver-xorg-input-synaptics
```

Audio. Do not install `pulseaudio`:

```bash
sudo apt install -y pipewire pipewire-pulse wireplumber pulseaudio-utils
```

i3:

```bash
sudo apt install -y i3-wm feh autorandr rfkill dex dunst xss-lock wezterm pcmanfm rofi network-manager maim xclip brightnessctl libnotify-bin mpv bluez python3 python3-pil python3-numpy papirus-icon-theme python3-gi gir1.2-nm-1.0 pipx
sudo curl -fsSL -o /usr/local/bin/networkmanager_dmenu https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu
sudo chmod +x /usr/local/bin/networkmanager_dmenu
```

autotiling, trixie:

```bash
sudo apt install -y autotiling
```

autotiling, noble/Mint:

```bash
pipx install autotiling
```

i3lock (i3lock-color, needed by `lock.sh`). Not packaged. Build from source:

```bash
git clone https://github.com/Raymo111/i3lock-color.git ~/src/i3lock-color
cd ~/src/i3lock-color
./install-i3lock-color.sh
```

Build dependencies: see the i3lock-color README (UNVERIFIED).

polybar:

```bash
sudo apt install -y polybar psmisc procps python3
```

Fonts. Source Han Sans JP is not packaged; `fonts-noto-cjk` has the same glyphs as Noto Sans CJK JP:

```bash
sudo apt install -y fonts-noto-cjk fonts-noto-color-emoji
mkdir -p ~/.local/share/fonts/JetBrainsMono
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts/JetBrainsMono
fc-cache -f
```

Japanese input (not configured by the repo):

```bash
sudo apt install -y fcitx5 fcitx5-mozc fcitx5-frontend-gtk3 fcitx5-frontend-qt5 fcitx5-config-qt qt5ct
```

Power, video, hardware. Do not install `tlp` or `i965-va-driver`:

```bash
sudo apt install -y power-profiles-daemon thermald intel-media-va-driver vainfo
```

zsh:

```bash
sudo apt install -y zsh zoxide eza fzf yt-dlp golang-go openjdk-25-jdk nodejs npm rustup xdg-user-dirs
```

fish:

```bash
sudo apt install -y fish zoxide eza
```

tmux:

```bash
sudo apt install -y tmux xclip fzf
```

nvim. Distro Neovim and tree-sitter-cli are too old for nvim-treesitter `main` (needs Neovim 0.12, tree-sitter-cli 0.26.1). Install Neovim from the release tarball; tree-sitter-cli is built in step 4:

```bash
sudo apt install -y ripgrep fd-find luarocks xclip ipython3 python3-venv nodejs npm gdb delve
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | sudo tar -xz -C /opt
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
pipx install ruff
```

jupytext, trixie:

```bash
sudo apt install -y python3-jupytext
```

jupytext, noble/Mint:

```bash
pipx install jupytext
```

scripts:

```bash
sudo apt install -y ffmpeg bc libreoffice util-linux xdg-user-dirs
```

fastfetch, trixie:

```bash
sudo apt install -y fastfetch
```

fastfetch on noble/Mint and ghostty on all three: not packaged. Install method UNVERIFIED.

## 4. Installers

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
curl -fsSL https://deno.land/install.sh | sh
curl -fsSL https://bun.sh/install | bash
curl -fsSL https://opencode.ai/install | bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
rustup default stable
rustup run stable cargo install --locked tree-sitter-cli
mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global
npm install -g prettier eslint_d
```

gradle: the Debian package is 4.4.1. Download a current release from https://services.gradle.org/distributions/ or use SDKMAN (UNVERIFIED).

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

Pick `Japanese 106-key` and layout `Japanese`:

```bash
sudo dpkg-reconfigure keyboard-configuration
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

`~/.xinitrc` comes from the `xinit` stow package. It loads `~/.Xresources`, sets the fcitx input method variables, and starts i3 for `startx`. With a display manager (LightDM on Mint), pick the i3 session instead; `~/.xinitrc` is then not read and the input method variables must be set another way (UNVERIFIED which file the display manager reads).

## 11. Machine-specific

```bash
mkdir -p ~/Downloads/png ~/Pictures
```

Put the wallpaper at `~/Downloads/png/eclipse.png`. Follow `docs/hardware-cf-sv7.md` on the CF-SV7.

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
| `readlink ~/.local/bin/fconv` | `../../Dotfiles/scripts/.local/bin/fconv` |
| `readlink ~/.config/i3` | `../Dotfiles/i3/.config/i3` (per-file links if `~/.config/i3` already existed) |
| `echo $SHELL` | `/usr/bin/zsh` |
| `i3lock --help 2>&1 \| grep -c -- --clock` | a number above 0 (i3lock-color). Output format UNVERIFIED |
| `pactl info \| grep 'Server Name'` | `Server Name: PulseAudio (on PipeWire ...)` |
| `systemctl is-active NetworkManager bluetooth power-profiles-daemon thermald` | `active` four times |
| `dpkg -l tlp i965-va-driver pulseaudio 2>/dev/null \| grep ^ii` | no output |
| `powerprofilesctl get` | `balanced` |
| `vainfo 2>&1 \| grep -i 'driver version'` | contains `Intel iHD driver` |
| `synclient -l \| grep CircularScrolling` | `CircularScrolling = 1` |
| `ls /sys/class/power_supply` | `AC  BAT1 ...` on the CF-SV7 |
| `xrandr \| grep ' connected'` | `eDP-1 connected ...` on the CF-SV7 |
| `fc-list : family \| grep -c 'JetBrainsMono Nerd Font'` | a number above 0 |
| `pgrep -a fcitx5` | a running `fcitx5` process. Autostart on the Debian family UNVERIFIED |
| `node --version` | `v20.x` on trixie, `v18.x` on noble |
| `nvim --version \| head -1` | `NVIM v0.12.x` or newer |
| `tree-sitter --version` | `tree-sitter 0.26.x` or newer |
| `echo $JAVA_HOME` | the installed JDK directory under `/usr/lib/jvm` |
| `eza --icons=auto ~ >/dev/null && echo ok` | `ok` (noble eza 0.18.2 support UNVERIFIED) |
