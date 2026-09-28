# Packages

Single source of truth. Install docs must match this file.

Verified 2026-09-28 against: Arch (`pacman -Si`, AUR RPC), Fedora 44 (mdapi, the backend of packages.fedoraproject.org), Debian 13 trixie and Ubuntu 24.04 noble (madison). Debian family means Debian, Ubuntu, and Linux Mint. Mint 22 uses the Ubuntu noble names. CachyOS uses the Arch column (UNVERIFIED for CachyOS-specific repos).

Legend:

| Mark | Meaning |
| --- | --- |
| `AUR` | Arch User Repository |
| `RPMF-free`, `RPMF-nonfree` | RPM Fusion repo required |
| `COPR x/y` | Fedora COPR repo required |
| `manual` | Not packaged. See the Manual installs table |
| `n/a` | Not needed on that distro |
| UNVERIFIED | Name or behavior not confirmed |

Where Debian and Ubuntu names differ, the cell reads `trixie / noble`.

## Base

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| git | lazy.nvim bootstrap, clone | `nvim/.config/nvim/lua/callo/lazy.lua` | git | git | git |
| stow | install | all packages | stow | stow | stow |
| C compiler, make | nvim-treesitter parsers, luarocks | `nvim/.config/nvim/lua/plugins/treesitter.lua` | base-devel | gcc make | build-essential |
| curl, tar, unzip, gzip, xz | nvim-treesitter, installers, Nerd Font and debug adapter archives | `lua/plugins/treesitter.lua`, `lua/plugins/dap.lua` | curl tar unzip gzip (xz is in `base`) | curl tar unzip gzip (xz preinstalled, UNVERIFIED) | curl tar unzip gzip xz-utils |

## X11 session (needed by i3, polybar, system)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| Xorg server | i3 session | n/a | xorg-server | xorg-x11-server-Xorg | xserver-xorg |
| startx | `xinit/.xinitrc` | n/a | xorg-xinit | xorg-x11-xinit | xinit |
| xrdb | i3 exec_always | `i3/.config/i3/config` | xorg-xrdb | xrdb | x11-xserver-utils |
| xsetroot | i3 exec_always | `i3/.config/i3/config` | xorg-xsetroot | xsetroot | x11-xserver-utils |
| xrandr | polybar launcher | `polybar/.config/polybar/launch.sh` | xorg-xrandr | xrandr | x11-xserver-utils |
| synaptics driver, synclient | circular scroll | `system/etc/X11/xorg.conf.d/70-synaptics.conf` | xf86-input-synaptics | xorg-x11-drv-synaptics-legacy | xserver-xorg-input-synaptics |
| xev | check whether F-keys reach X | `docs/hardware-cf-sv7.md` | xorg-xev | xev | x11-utils |

## i3 package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| i3, i3-msg, i3-nagbar | window manager | `i3/.config/i3/config` | i3-wm | i3 | i3-wm |
| feh | wallpaper | `i3/.config/i3/config` | feh | feh | feh |
| autorandr | display profile at login | `i3/.config/i3/config` | autorandr | autorandr | autorandr |
| rfkill | unblock bluetooth at login | `i3/.config/i3/config` | util-linux | util-linux | rfkill |
| autotiling | tiling direction | `i3/.config/i3/config` | autotiling | manual (pipx) | autotiling / manual (pipx) |
| dex | XDG autostart | `i3/.config/i3/config` | dex | dex-autostart | dex |
| dunst | notifications | `i3/.config/i3/config` | dunst | dunst | dunst |
| xss-lock | lock on suspend | `i3/.config/i3/config` | xss-lock | xss-lock | xss-lock |
| wezterm | `$terminal` | `i3/.config/i3/config` | wezterm | COPR wezfurlong/wezterm-nightly | manual (apt.fury.io/wez repo) |
| pcmanfm | `$fileManager` | `i3/.config/i3/config` | pcmanfm | pcmanfm | pcmanfm |
| rofi | launcher, menus | `i3/.config/i3/config`, `i3/.config/i3/scripts/*.sh` | rofi | rofi | rofi |
| debugpy | `python3 -m venv ~/.local/share/nvim/debugpy && ~/.local/share/nvim/debugpy/bin/pip install debugpy` |
| js-debug | `curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz \| tar -xz -C ~/.local/share/nvim` (creates `js-debug/`) |
| netcoredbg | `curl -fsSL https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz \| tar -xz -C ~/.local/share && ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg` |
| Rose Pine GTK theme | `mkdir -p ~/.themes && curl -fsSL https://github.com/rose-pine/gtk/releases/download/v2.2.0/gtk3.tar.gz \| tar -xz --strip-components=1 -C ~/.themes gtk3/rose-pine-gtk` |
| Rose Pine cursor | `mkdir -p ~/.icons && curl -fsSL https://github.com/rose-pine/cursor/releases/download/v1.1.0/BreezeX-RosePine-Linux.tar.xz \| tar -xJ -C ~/.icons` |
| networkmanager_dmenu | `$mod+n` | `i3/.config/i3/config` | networkmanager-dmenu | manual | manual |
| maim | screenshots, lock image | `i3/.config/i3/config`, `i3/.config/i3/scripts/lock-gen.py` | maim | maim | maim |
| xclip | screenshot to clipboard | `i3/.config/i3/config` | xclip | xclip | xclip |
| wpctl | volume keys | `i3/.config/i3/config` | wireplumber | wireplumber | wireplumber |
| brightnessctl | brightness keys | `i3/.config/i3/config` | brightnessctl | brightnessctl | brightnessctl |
| pactl | audio menus, polybar volume clicks | `i3/.config/i3/scripts/audio-menu.sh`, `audio-switch.sh`, `polybar/.config/polybar/config.ini` | libpulse | pulseaudio-utils | pulseaudio-utils |
| notify-send | script notifications | `i3/.config/i3/scripts/*.sh`, `i3lock/bin/lock.sh` | libnotify | libnotify | libnotify-bin |
| mpv | switch sounds | `i3/.config/i3/scripts/audio-switch.sh` | mpv | mpv | mpv |
| bluetoothctl | bluetooth menu | `i3/.config/i3/scripts/bluetooth-menu.sh` | bluez bluez-utils | bluez | bluez |
| python3, Pillow, NumPy | lock image | `i3/.config/i3/scripts/lock-gen.py` | python python-pillow python-numpy | python3 python3-pillow python3-numpy | python3 python3-pil python3-numpy |
| i3lock-color | styled lock screen (falls back to plain i3lock) | `i3lock/bin/lock.sh` | i3lock-color (AUR) | manual (several COPRs exist, none verified) | manual (build from source) |
| Papirus icons | dunst icon path | `dunst/.config/dunst/dunstrc` | papirus-icon-theme | papirus-icon-theme | papirus-icon-theme |
| NetworkManager | debugpy | `python3 -m venv ~/.local/share/nvim/debugpy && ~/.local/share/nvim/debugpy/bin/pip install debugpy` |
| js-debug | `curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz \| tar -xz -C ~/.local/share/nvim` (creates `js-debug/`) |
| netcoredbg | `curl -fsSL https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz \| tar -xz -C ~/.local/share && ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg` |
| networkmanager_dmenu | n/a | networkmanager | NetworkManager | network-manager |

## polybar package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| polybar | bar | `polybar/.config/polybar/*` | polybar | polybar | polybar |
| killall | launcher | `polybar/.config/polybar/launch.sh` | psmisc | psmisc | psmisc |
| pgrep | launcher | `polybar/.config/polybar/launch.sh` | procps-ng | procps-ng | procps |

## Audio

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| PipeWire | audio server | n/a | pipewire | pipewire | pipewire |
| PulseAudio shim | pactl, polybar `internal/pulseaudio` | `polybar/.config/polybar/config.ini` | pipewire-pulse | pipewire-pulseaudio | pipewire-pulse |
| WirePlumber | session manager, wpctl | `i3/.config/i3/config` | wireplumber | wireplumber | wireplumber |

Do not install `pulseaudio` alongside `pipewire-pulse`. They conflict.

## Look (gtk, picom packages)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| picom | optional compositor, not started by i3 (suspected of lagging Brave on the CF-SV7, unconfirmed) | `picom/.config/picom/picom.conf` | picom | picom | picom |
| Rose Pine GTK theme `rose-pine-gtk` | GTK apps | `gtk/.config/gtk-3.0/settings.ini`, `gtk/.gtkrc-2.0` | rose-pine-gtk-theme (AUR) | manual | manual |
| Rose Pine cursor `BreezeX-RosePine-Linux` | cursor | `gtk/.icons/default/index.theme`, `xresources/.Xresources` | rose-pine-cursor (AUR) | manual | manual |
| Papirus icons `Papirus-Dark` | GTK icons, dunst | `gtk/.config/gtk-3.0/settings.ini`, `dunst/.config/dunst/dunstrc` | papirus-icon-theme | papirus-icon-theme | papirus-icon-theme |
| powerprofilesctl | polybar battery click, `osd.sh profile` | `i3/.config/i3/scripts/osd.sh` | power-profiles-daemon | power-profiles-daemon | power-profiles-daemon |

## Fonts

| Font | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| JetBrainsMono Nerd Font | i3, polybar, rofi, dunst, lock, wezterm | `i3/.config/i3/config`, `polybar/.config/polybar/config.ini`, `wezterm/.config/wezterm/wezterm.lua` | ttf-jetbrains-mono-nerd | manual | manual |
| Source Han Sans JP | i3 title font | `i3/.config/i3/config` | adobe-source-han-sans-jp-fonts | adobe-source-han-sans-jp-fonts | not packaged. fonts-noto-cjk has the same glyphs under the name Noto Sans CJK JP. Whether i3 falls back to it: UNVERIFIED |
| Noto Sans CJK JP | wezterm fallback | `wezterm/.config/wezterm/wezterm.lua` | noto-fonts-cjk | google-noto-sans-cjk-fonts | fonts-noto-cjk |
| Noto Color Emoji | wezterm fallback | `wezterm/.config/wezterm/wezterm.lua` | noto-fonts-emoji | google-noto-color-emoji-fonts | fonts-noto-color-emoji |

## Japanese input

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| fcitx5 | IME | `xinit/.xinitrc`, `wezterm/.config/wezterm/wezterm.lua` | fcitx5 | fcitx5 fcitx5-autostart | fcitx5 |
| Mozc engine | Japanese | n/a | fcitx5-mozc | fcitx5-mozc | fcitx5-mozc |
| GTK module | GTK_IM_MODULE | n/a | fcitx5-gtk | fcitx5-gtk | fcitx5-frontend-gtk3 |
| Qt module | QT_IM_MODULE | n/a | fcitx5-qt | fcitx5-qt | fcitx5-frontend-qt5 |
| Config tool | setup | n/a | fcitx5-configtool | fcitx5-configtool | fcitx5-config-qt |
| qt5ct | QT_QPA_PLATFORMTHEME | `zsh/.zshrc`, `fish/.config/fish/config.fish` | qt5ct | qt5ct | qt5ct |

## Power, video, hardware (not configured in repo)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| power-profiles-daemon | power profiles | n/a | power-profiles-daemon | power-profiles-daemon | power-profiles-daemon |
| thermald | Intel thermal | n/a | thermald | thermald | thermald |
| acpid | optional fallback for F4, F5, F6 when they do not reach X | `system/install.sh` | acpid | acpid | acpid |
| Intel VA-API (iHD) | video decode | n/a | intel-media-driver | libva-intel-media-driver, or intel-media-driver (RPMF-nonfree) for full codecs | intel-media-va-driver, or intel-media-va-driver-non-free (Debian non-free, Ubuntu multiverse) |
| vainfo | verify VA-API | n/a | libva-utils | libva-utils | vainfo |

Do not install `tlp` with power-profiles-daemon. On Fedora, `tuned-ppd` conflicts with power-profiles-daemon; swap it out. Do not install `libva-intel-driver` (Arch) or `i965-va-driver` (Debian family) with the iHD driver.

## Shells

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| zsh | active login shell | `zsh/.zshrc` | zsh | zsh | zsh |
| oh-my-zsh | zsh framework | `zsh/.zshrc` | manual | manual | manual |
| fish | alternate shell | `fish/.config/fish/config.fish` | fish | fish | fish |
| zoxide | `cd` jumping | `zsh/.zshrc`, `config.fish` | zoxide | zoxide | zoxide |
| eza | `ls` aliases | `zsh/.zshrc`, `config.fish` | eza | eza | eza (noble 0.18.2: `--icons=auto` support UNVERIFIED) |
| fzf | tmux-sessionizer | `bin/tmux-sessionizer` | fzf | fzf | fzf |
| yt-dlp | `ytdl-*` aliases | `zsh/.zshrc` | yt-dlp | yt-dlp | yt-dlp (noble: noble-backports) |
| gradle | `ginit` | `zsh/.zshrc` | gradle | manual | manual (trixie ships 4.4.1, too old for current projects: UNVERIFIED) |
| go | GOPATH in PATH | `zsh/.zshrc` | go | golang | golang-go |
| bun | PATH, `preflight`, ipynb-peek build | `zsh/.zshrc`, `nvim/.config/nvim/lua/plugins/ipynb-peek.lua` | bun | manual | manual |
| deno | PATH, optional `~/.deno/env` | `zsh/.zshrc`, `config.fish` | deno | manual | manual |
| ghcup | PATH | `zsh/.zshrc` | ghcup-hs-bin (AUR) or manual | manual | manual |
| JDK | JAVA_HOME, gradle | `zsh/.zshrc`, `config.fish` | jdk-openjdk (currently 27) | java-latest-openjdk-devel (currently 27) | openjdk-25-jdk (26 and 27 not packaged) |
| opencode | PATH | `zsh/.zshrc` | opencode | manual | manual |
| Node.js, npm | markdown-preview, md-peek, live-server, js-debug, jqinit | `lua/plugins/markdown.lua`, `md-peek.lua`, `liveserver.lua`, `dap.lua` | nodejs npm | nodejs24 nodejs24-bin nodejs24-npm nodejs24-npm-bin | nodejs npm |
| rustup, cargo | `~/.cargo/bin` in PATH, tree-sitter-cli build (Debian family) | `zsh/.zshrc`, `config.fish` | rustup | rustup | rustup |
| xdg-user-dir | organize-downloads (optional) | `scripts/.local/bin/organize-downloads` | xdg-user-dirs | xdg-user-dirs | xdg-user-dirs |

## tmux package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| tmux | multiplexer | `tmux/.tmux.conf` | tmux | tmux | tmux |
| xclip | copy to clipboard | `tmux/.tmux.conf` | xclip | xclip | xclip |
| fzf | sessionizer | `bin/tmux-sessionizer` | fzf | fzf | fzf |
| hopes | popup on `prefix t` / `prefix T` | `tmux/.tmux.conf` | UNVERIFIED (not in repos, AUR, or crates.io) | UNVERIFIED | UNVERIFIED |

## nvim package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| Neovim 0.12+ | nvim-treesitter `main` requires 0.12 | `lua/plugins/treesitter.lua` | neovim | neovim | manual (trixie 0.10.4, noble 0.9.5 too old) |
| tree-sitter-cli 0.26.1+ | parser builds | `lua/plugins/treesitter.lua` | tree-sitter-cli | tree-sitter-cli | manual via cargo (trixie 0.22.6, noble 0.20.8 too old) |
| ripgrep | telescope live_grep | `lua/plugins/telescope.lua` | ripgrep | ripgrep | ripgrep |
| fd | telescope find_files (optional) | `lua/plugins/telescope.lua` | fd | fd-find | fd-find |
| luarocks | lazy.nvim rockspec support | `lua/callo/lazy.lua` | luarocks | luarocks | luarocks |
| xclip | `clipboard=unnamedplus` | `lua/callo/set.lua` | xclip | xclip | xclip |
| ruff | conform python | `lua/plugins/conform.lua` | ruff | ruff | manual (pipx) |
| prettier | conform json/css/html/md/svelte | `lua/plugins/conform.lua` | prettier | manual (npm) | manual (npm) |
| eslint_d | conform js/ts | `lua/plugins/conform.lua` | eslint_d | manual (npm) | manual (npm) |
| live-server | live-server.nvim build | `lua/plugins/liveserver.lua` | npm (build step runs it) | npm | npm |
| Brave browser | live-server browser | `lua/plugins/liveserver.lua` | UNVERIFIED | UNVERIFIED | UNVERIFIED |
| ipython | iron.nvim REPL | `lua/plugins/python.lua` | ipython | python3-ipython | ipython3 |
| jupytext | jupytext.vim | `lua/plugins/python.lua` | python-jupytext (AUR) | python3-jupytext | python3-jupytext / manual (pipx) |
| bun | ipynb-peek build | `lua/plugins/ipynb-peek.lua` | bun | manual | manual |
| gdb 14+ | C, C++, Rust debugging | `lua/plugins/dap.lua` | gdb | gdb | gdb |
| delve | Go debugging | `lua/plugins/dap.lua` | delve | delve | delve |
| debugpy | Python debugging | `lua/plugins/dap.lua` | manual (venv) | manual (venv) | manual (venv, needs python3-venv) |
| js-debug | JavaScript, TypeScript debugging | `lua/plugins/dap.lua` | manual | manual | manual |
| netcoredbg | C# debugging | `lua/plugins/dap.lua` | manual | manual | manual |

No LSP is configured. typst-preview.nvim downloads its own binaries (`lua/plugins/typst.lua`). debugpy, js-debug and netcoredbg use one install recipe on every distro (see Manual installs) so the paths in `dap.lua` match. No plugin in this repo needs luarocks right now; lazy.nvim's `rocks` support (`lua/callo/lazy.lua`) is enabled by default, so a future plugin that ships a rockspec picks it up automatically. `:checkhealth lazy` reports "no plugins require luarocks" until one does.

## scripts package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| ffmpeg, ffprobe | fconv | `scripts/.local/bin/fconv` | ffmpeg | ffmpeg (RPMF-free). `ffmpeg-free` exists in Fedora but libx264 support is UNVERIFIED | ffmpeg |
| bc | fconv | `scripts/.local/bin/fconv` | bc | bc | bc |
| LibreOffice | fconv documents (optional) | `scripts/.local/bin/fconv` | libreoffice-fresh | libreoffice | libreoffice |
| flock | organize-downloads | `scripts/.local/bin/organize-downloads` | util-linux | util-linux | util-linux |

## Other packages

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| fastfetch | system info | `fastfetch/.config/fastfetch/config.jsonc` | fastfetch | fastfetch | fastfetch / manual (not in noble) |
| ghostty | terminal | `ghostty/.config/ghostty/config` | ghostty | COPR scottames/ghostty | manual (UNVERIFIED) |

## KDE only

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| Plasma X11 session | synaptics under KDE | n/a | UNVERIFIED | plasma-workspace-x11 | UNVERIFIED |
| balooctl6 | disable indexer | n/a | UNVERIFIED | UNVERIFIED | UNVERIFIED |

## Manual installs

| Tool | Command |
| --- | --- |
| oh-my-zsh | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc` |
| deno | `curl -fsSL https://deno.land/install.sh \| sh` |
| bun | `curl -fsSL https://bun.sh/install \| bash` |
| ghcup | `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \| sh` |
| opencode | `curl -fsSL https://opencode.ai/install \| bash` |
| rustup toolchain | Arch, Debian family: `rustup default stable`. Fedora: `rustup-init -y` |
| JetBrainsMono Nerd Font | `mkdir -p ~/.local/share/fonts/JetBrainsMono && curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \| tar -xJ -C ~/.local/share/fonts/JetBrainsMono && fc-cache -f` |
| Neovim (Debian family) | `curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \| sudo tar -xz -C /opt && sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim` |
| tree-sitter-cli (Debian family) | `rustup run stable cargo install --locked tree-sitter-cli` |
| npm tools | `npm config set prefix ~/.npm-global && npm install -g prettier eslint_d` |
| pipx tools | `pipx install autotiling ruff jupytext` (install only the ones your distro lacks) |
| debugpy | `python3 -m venv ~/.local/share/nvim/debugpy && ~/.local/share/nvim/debugpy/bin/pip install debugpy` |
| js-debug | `curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz \| tar -xz -C ~/.local/share/nvim` (creates `js-debug/`) |
| netcoredbg | `curl -fsSL https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz \| tar -xz -C ~/.local/share && ln -sf ~/.local/share/netcoredbg/netcoredbg ~/.local/bin/netcoredbg` |
| networkmanager_dmenu | `sudo curl -fsSL -o /usr/local/bin/networkmanager_dmenu https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu && sudo chmod +x /usr/local/bin/networkmanager_dmenu`. Needs PyGObject and libnm typelibs: Fedora `python3-gobject NetworkManager-libnm`, Debian family `python3-gi gir1.2-nm-1.0` |
| i3lock-color | Clone https://github.com/Raymo111/i3lock-color and run `./install-i3lock-color.sh`. Build dependencies: see its README (UNVERIFIED per distro) |
| wezterm apt repo | See `docs/install-debian.md` |
| gradle | Download from https://services.gradle.org/distributions/ or use SDKMAN (UNVERIFIED) |
| hopes | UNVERIFIED. Must end up at `~/.cargo/bin/hopes` |

## Not stow packages

| Directory | Use |
| --- | --- |
| `bin/` | Used in place. `$DOTFILES/bin` is added to PATH by zsh and fish and called by tmux. `DOTFILES` is resolved from the stowed symlinks |
| `system/` | Copied into `/etc` by `system/install.sh` |
| `extras/` | Tools for other machines (`g14-power` for an ASUS G14). Not stowed |
| `discord/` | Vencord theme. Copy by hand into the Vencord themes folder |
| `docs/`, `assets/` | Documentation |
