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
| git | lazy.nvim bootstrap, clone | `nvim/.config/nvim/lua/callo/lazy.lua:4` | git | git | git |
| stow | install | all packages | stow | stow | stow |
| C compiler, make | nvim-treesitter parsers, luarocks | `nvim/.config/nvim/lua/plugins/treesitter.lua` | base-devel | gcc make | build-essential |
| curl, tar, unzip, gzip, xz | nvim-treesitter, mason downloads, installers, Nerd Font archive | `lua/plugins/treesitter.lua`, `lua/plugins/lsp.lua` | curl tar unzip gzip (xz is in `base`) | curl tar unzip gzip (xz preinstalled, UNVERIFIED) | curl tar unzip gzip xz-utils |

## X11 session (needed by i3, polybar, system)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| Xorg server | i3 session | n/a | xorg-server | xorg-x11-server-Xorg | xserver-xorg |
| startx | `~/.xinitrc` (not in repo) | n/a | xorg-xinit | xorg-x11-xinit | xinit |
| xrdb | i3 exec_always | `i3/.config/i3/config:58` | xorg-xrdb | xrdb | x11-xserver-utils |
| xsetroot | i3 exec_always | `i3/.config/i3/config:59` | xorg-xsetroot | xsetroot | x11-xserver-utils |
| xrandr | polybar launcher | `polybar/.config/polybar/launch.sh:14` | xorg-xrandr | xrandr | x11-xserver-utils |
| synaptics driver, synclient | circular scroll | `system/etc/X11/xorg.conf.d/70-synaptics.conf` | xf86-input-synaptics | xorg-x11-drv-synaptics-legacy | xserver-xorg-input-synaptics |

## i3 package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| i3, i3-msg, i3-nagbar | window manager | `i3/.config/i3/config` | i3-wm | i3 | i3-wm |
| feh | wallpaper | `i3/.config/i3/config:23` | feh | feh | feh |
| autorandr | display profile at login | `i3/.config/i3/config:53` | autorandr | autorandr | autorandr |
| rfkill | unblock bluetooth at login | `i3/.config/i3/config:54` | util-linux | util-linux | rfkill |
| autotiling | tiling direction | `i3/.config/i3/config:60` | autotiling | manual (pipx) | autotiling / manual (pipx) |
| dex | XDG autostart | `i3/.config/i3/config:63` | dex | dex-autostart | dex |
| dunst | notifications | `i3/.config/i3/config:64` | dunst | dunst | dunst |
| xss-lock | lock on suspend | `i3/.config/i3/config:65` | xss-lock | xss-lock | xss-lock |
| wezterm | `$terminal` | `i3/.config/i3/config:44` | wezterm | COPR wezfurlong/wezterm-nightly | manual (apt.fury.io/wez repo) |
| pcmanfm | `$fileManager` | `i3/.config/i3/config:45` | pcmanfm | pcmanfm | pcmanfm |
| rofi | launcher, menus | `i3/.config/i3/config:46`, `i3/.config/i3/scripts/*.sh` | rofi | rofi | rofi |
| networkmanager_dmenu | `$mod+n` | `i3/.config/i3/config:75` | networkmanager-dmenu | manual | manual |
| maim | screenshots, lock image | `i3/.config/i3/config:90-96`, `i3/.config/i3/scripts/lock-gen.py:13` | maim | maim | maim |
| xclip | screenshot to clipboard | `i3/.config/i3/config:90,93` | xclip | xclip | xclip |
| wpctl | volume keys | `i3/.config/i3/config:103-106` | wireplumber | wireplumber | wireplumber |
| brightnessctl | brightness keys | `i3/.config/i3/config:109-110` | brightnessctl | brightnessctl | brightnessctl |
| pactl | audio menus, polybar volume clicks | `i3/.config/i3/scripts/audio-menu.sh`, `audio-switch.sh`, `polybar/.config/polybar/config.ini:182-184` | libpulse | pulseaudio-utils | pulseaudio-utils |
| notify-send | script notifications | `i3/.config/i3/scripts/*.sh`, `i3lock/bin/lock.sh:6` | libnotify | libnotify | libnotify-bin |
| mpv | switch sounds | `i3/.config/i3/scripts/audio-switch.sh:46` | mpv | mpv | mpv |
| bluetoothctl | bluetooth menu | `i3/.config/i3/scripts/bluetooth-menu.sh` | bluez bluez-utils | bluez | bluez |
| python3, Pillow, NumPy | lock image | `i3/.config/i3/scripts/lock-gen.py` | python python-pillow python-numpy | python3 python3-pillow python3-numpy | python3 python3-pil python3-numpy |
| i3lock-color | lock screen | `i3lock/bin/lock.sh:10-39` | i3lock-color (AUR) | manual (several COPRs exist, none verified) | manual (build from source) |
| Papirus icons | dunst icon path | `dunst/.config/dunst/dunstrc:24` | papirus-icon-theme | papirus-icon-theme | papirus-icon-theme |
| NetworkManager | networkmanager_dmenu | n/a | networkmanager | NetworkManager | network-manager |

## polybar package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| polybar | bar | `polybar/.config/polybar/*` | polybar | polybar | polybar |
| killall | launcher | `polybar/.config/polybar/launch.sh:7` | psmisc | psmisc | psmisc |
| pgrep | launcher | `polybar/.config/polybar/launch.sh:8` | procps-ng | procps-ng | procps |
| python3 | spinner module | `polybar/.config/polybar/config.ini:133` | python | python3 | python3 |

## Audio

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| PipeWire | audio server | n/a | pipewire | pipewire | pipewire |
| PulseAudio shim | pactl, polybar `internal/pulseaudio` | `polybar/.config/polybar/config.ini:166` | pipewire-pulse | pipewire-pulseaudio | pipewire-pulse |
| WirePlumber | session manager, wpctl | `i3/.config/i3/config:103-106` | wireplumber | wireplumber | wireplumber |

Do not install `pulseaudio` alongside `pipewire-pulse`. They conflict.

## Fonts

| Font | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| JetBrainsMono Nerd Font | i3, polybar, rofi, dunst, lock, wezterm | `i3/.config/i3/config:13`, `polybar/.config/polybar/config.ini:56`, `wezterm/.config/wezterm/wezterm.lua:11` | ttf-jetbrains-mono-nerd | manual | manual |
| Source Han Sans JP | i3 title font | `i3/.config/i3/config:13` | adobe-source-han-sans-jp-fonts | adobe-source-han-sans-jp-fonts | not packaged. fonts-noto-cjk has the same glyphs under the name Noto Sans CJK JP. Whether i3 falls back to it: UNVERIFIED |
| Noto Sans CJK JP | wezterm fallback | `wezterm/.config/wezterm/wezterm.lua:12` | noto-fonts-cjk | google-noto-sans-cjk-fonts | fonts-noto-cjk |
| Noto Color Emoji | wezterm fallback | `wezterm/.config/wezterm/wezterm.lua:13` | noto-fonts-emoji | google-noto-color-emoji-fonts | fonts-noto-color-emoji |

## Japanese input (not configured in repo)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| fcitx5 | IME | `~/.xinitrc` (not in repo), `wezterm/.config/wezterm/wezterm.lua:21` | fcitx5 | fcitx5 fcitx5-autostart | fcitx5 |
| Mozc engine | Japanese | n/a | fcitx5-mozc | fcitx5-mozc | fcitx5-mozc |
| GTK module | GTK_IM_MODULE | n/a | fcitx5-gtk | fcitx5-gtk | fcitx5-frontend-gtk3 |
| Qt module | QT_IM_MODULE | n/a | fcitx5-qt | fcitx5-qt | fcitx5-frontend-qt5 |
| Config tool | setup | n/a | fcitx5-configtool | fcitx5-configtool | fcitx5-config-qt |
| qt5ct | QT_QPA_PLATFORMTHEME | `zsh/.zshrc:14`, `fish/.config/fish/config.fish:6` | qt5ct | qt5ct | qt5ct |

## Power, video, hardware (not configured in repo, except acpid placeholders)

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| power-profiles-daemon | power profiles | n/a | power-profiles-daemon | power-profiles-daemon | power-profiles-daemon |
| thermald | Intel thermal | n/a | thermald | thermald | thermald |
| acpid | F4, F5, F6 keys | `system/install.sh:4-6` | acpid | acpid | acpid |
| Intel VA-API (iHD) | video decode | n/a | intel-media-driver | libva-intel-media-driver, or intel-media-driver (RPMF-nonfree) for full codecs | intel-media-va-driver, or intel-media-va-driver-non-free (Debian non-free, Ubuntu multiverse) |
| vainfo | verify VA-API | n/a | libva-utils | libva-utils | vainfo |

Do not install `tlp` with power-profiles-daemon. On Fedora, `tuned-ppd` conflicts with power-profiles-daemon; swap it out. Do not install `libva-intel-driver` (Arch) or `i965-va-driver` (Debian family) with the iHD driver.

## Shells

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| zsh | active login shell | `zsh/.zshrc` | zsh | zsh | zsh |
| oh-my-zsh | zsh framework | `zsh/.zshrc:5-9` | manual | manual | manual |
| fish | alternate shell | `fish/.config/fish/config.fish` | fish | fish | fish |
| zoxide | `cd` jumping | `zsh/.zshrc:37`, `config.fish:55` | zoxide | zoxide | zoxide |
| eza | `ls` aliases | `zsh/.zshrc:48-51`, `config.fish:31-34` | eza | eza | eza (noble 0.18.2: `--icons=auto` support UNVERIFIED) |
| fzf | tmux-sessionizer | `bin/tmux-sessionizer:70` | fzf | fzf | fzf |
| yt-dlp | `ytdl-*` aliases | `zsh/.zshrc:58-59` | yt-dlp | yt-dlp | yt-dlp (noble: noble-backports) |
| gradle | `ginit` | `zsh/.zshrc:71` | gradle | manual | manual (trixie ships 4.4.1, too old for current projects: UNVERIFIED) |
| go | GOPATH in PATH | `zsh/.zshrc:76-78` | go | golang | golang-go |
| bun | PATH, `preflight`, ipynb-peek build | `zsh/.zshrc:80-90`, `nvim/.config/nvim/lua/plugins/ipynb-peek.lua:7` | bun | manual | manual |
| deno | `~/.deno/env` | `zsh/.zshrc:98` | manual (installer, repo expects `~/.deno/env`) | manual | manual |
| ghcup | PATH | `zsh/.zshrc:30,85` | ghcup-hs-bin (AUR) or manual | manual | manual |
| JDK | JAVA_HOME, jdtls | `zsh/.zshrc:94`, `config.fish:10` | jdk-openjdk (currently 27) | java-latest-openjdk-devel (currently 27) | openjdk-25-jdk (26 and 27 not packaged) |
| opencode | PATH | `zsh/.zshrc:93` | opencode | manual | manual |
| Node.js, npm | markdown-preview, md-peek, live-server, mason LSPs, jqinit | `lua/plugins/markdown.lua:6`, `md-peek.lua:7`, `liveserver.lua:3`, `lsp.lua:16` | nodejs npm | nodejs24 nodejs24-bin nodejs24-npm nodejs24-npm-bin | nodejs npm |
| rustup, cargo | `~/.cargo/bin` in PATH, clippy for rust_analyzer | `zsh/.zshrc:24,36`, `lua/plugins/lsp.lua:153` | rustup | rustup | rustup |
| xdg-user-dir | organize-downloads (optional) | `scripts/.local/bin/organize-downloads:11` | xdg-user-dirs | xdg-user-dirs | xdg-user-dirs |

## tmux package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| tmux | multiplexer | `tmux/.tmux.conf` | tmux | tmux | tmux |
| xclip | copy to clipboard | `tmux/.tmux.conf:15-16` | xclip | xclip | xclip |
| fzf | sessionizer | `bin/tmux-sessionizer:70` | fzf | fzf | fzf |
| hopes | popup on `prefix t` / `prefix T` | `tmux/.tmux.conf:43-44` | UNVERIFIED (not in repos, AUR, or crates.io) | UNVERIFIED | UNVERIFIED |

## nvim package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| Neovim 0.12+ | nvim-treesitter `main` requires 0.12 | `lua/plugins/treesitter.lua:3` | neovim | neovim | manual (trixie 0.10.4, noble 0.9.5 too old) |
| tree-sitter-cli 0.26.1+ | parser builds | `lua/plugins/treesitter.lua:4` | tree-sitter-cli | tree-sitter-cli | manual via cargo (trixie 0.22.6, noble 0.20.8 too old) |
| ripgrep | telescope live_grep | `lua/plugins/telescope.lua:27` | ripgrep | ripgrep | ripgrep |
| fd | telescope find_files (optional) | `lua/plugins/telescope.lua:25` | fd | fd-find | fd-find |
| luarocks | lazy.nvim rockspec support | `lua/callo/lazy.lua:26` | luarocks | luarocks | luarocks |
| xclip | `clipboard=unnamedplus` | `lua/callo/set.lua:41` | xclip | xclip | xclip |
| ruff | conform python | `lua/plugins/conform.lua:5` | ruff | ruff | manual (pipx) |
| prettier | conform json/css/html/md/svelte | `lua/plugins/conform.lua:10-14` | prettier | manual (npm) | manual (npm) |
| eslint_d | conform js/ts | `lua/plugins/conform.lua:6-10` | eslint_d | manual (npm) | manual (npm) |
| live-server | live-server.nvim build | `lua/plugins/liveserver.lua:3` | npm (build step runs it) | npm | npm |
| Brave browser | live-server browser | `lua/plugins/liveserver.lua:8` | UNVERIFIED | UNVERIFIED | UNVERIFIED |
| ipython | iron.nvim REPL | `lua/plugins/python.lua:10` | ipython | python3-ipython | ipython3 |
| jupytext | jupytext.vim | `lua/plugins/python.lua:102` | python-jupytext (AUR) | python3-jupytext | python3-jupytext / manual (pipx) |
| JDK | jdtls | `lua/plugins/jdtls.lua:21` | jdk-openjdk | java-latest-openjdk-devel | openjdk-25-jdk |
| bun | ipynb-peek build | `lua/plugins/ipynb-peek.lua:7` | bun | manual | manual |

Mason installs these LSPs itself (`lua/plugins/lsp.lua:16-19`): lua_ls, tailwindcss, html, vtsls, rust_analyzer, svelte, eslint, pyright. The npm-based ones need Node.js and npm. typst-preview.nvim downloads its own binaries (`lua/plugins/typst.lua:6`).

## scripts package

| Tool | Used by | Where | Arch | Fedora | Debian family |
| --- | --- | --- | --- | --- | --- |
| ffmpeg, ffprobe | fconv | `scripts/.local/bin/fconv:25,100-140` | ffmpeg | ffmpeg (RPMF-free). `ffmpeg-free` exists in Fedora but libx264 support is UNVERIFIED | ffmpeg |
| bc | fconv | `scripts/.local/bin/fconv:25,114` | bc | bc | bc |
| LibreOffice | fconv documents (optional) | `scripts/.local/bin/fconv:18-22` | libreoffice-fresh | libreoffice | libreoffice |
| flock | organize-downloads | `scripts/.local/bin/organize-downloads:28` | util-linux | util-linux | util-linux |
| uv, uvx | vendored binaries | `scripts/.local/bin/uv`, `uvx` | n/a | n/a | n/a |

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
| rustup toolchain | Arch, Debian family: `rustup default stable && rustup component add clippy`. Fedora: `rustup-init -y` first |
| JetBrainsMono Nerd Font | `mkdir -p ~/.local/share/fonts/JetBrainsMono && curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \| tar -xJ -C ~/.local/share/fonts/JetBrainsMono && fc-cache -f` |
| Neovim (Debian family) | `curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \| sudo tar -xz -C /opt && sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim` |
| tree-sitter-cli (Debian family) | `rustup run stable cargo install --locked tree-sitter-cli` |
| npm tools | `npm config set prefix ~/.npm-global && npm install -g prettier eslint_d` |
| pipx tools | `pipx install autotiling ruff jupytext` (install only the ones your distro lacks) |
| networkmanager_dmenu | `sudo curl -fsSL -o /usr/local/bin/networkmanager_dmenu https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu && sudo chmod +x /usr/local/bin/networkmanager_dmenu`. Needs PyGObject and libnm typelibs: Fedora `python3-gobject NetworkManager-libnm`, Debian family `python3-gi gir1.2-nm-1.0` |
| i3lock-color | Clone https://github.com/Raymo111/i3lock-color and run `./install-i3lock-color.sh`. Build dependencies: see its README (UNVERIFIED per distro) |
| wezterm apt repo | See `docs/install-debian.md` |
| gradle | Download from https://services.gradle.org/distributions/ or use SDKMAN (UNVERIFIED) |
| hopes | UNVERIFIED. Must end up at `~/.cargo/bin/hopes` |

## Not stow packages

| Directory | Use |
| --- | --- |
| `bin/` | Used in place. `~/Dotfiles/bin` is in PATH (`zsh/.zshrc:25`) and called by tmux (`tmux/.tmux.conf:34-41`) |
| `system/` | Copied into `/etc` by `system/install.sh` |
| `discord/` | Vencord theme. Copy by hand into the Vencord themes folder |
| `docs/`, `assets/` | Documentation |
