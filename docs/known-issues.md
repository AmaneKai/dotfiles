# Known issues

Open problems in the configs. Checked 2026-09-28 on branch `linux`; line numbers refer to that state. Items fixed in the same audit are not listed.

## Missing from the repo

| Item | Effect |
| --- | --- |
| synclient decimal options | MinSpeed, MaxSpeed, AccelFactor, CircScrollDelta are not set anywhere. Values unknown |
| Wallpaper `~/Downloads/png/eclipse.png` | Black background on a fresh machine (`i3/.config/i3/config:8`) |
| hopes | `prefix t` and `prefix T` open an empty popup until `~/.cargo/bin/hopes` exists. Source unknown |

## Hardcoded values

| File | Line | Value |
| --- | --- | --- |
| `i3/.config/i3/config` | 8 | Wallpaper path |
| `i3/.config/i3/config` | 21, 24 | `wezterm`, `pcmanfm` |
| `i3/.config/i3/scripts/audio-switch.sh` | 15-16 | Mic matched by name `FIFINE`. "AirPods" means the first Bluetooth audio card, so any connected headset is used |
| `polybar/.config/polybar/config.ini` | 146-147 | `BAT1`, `AC` (CF-SV7 names) |
| `system/etc/X11/xorg.conf.d/70-synaptics.conf` | 12-15 | Touchpad edges for the CF-SV7 circular pad |
| `autorandr/.config/autorandr/laptop/` | all | Profile for the CF-SV7 panel (`eDP-1`, 1920x1200). `autorandr --save laptop` on another machine overwrites it in the repo |
| `bin/tmux-sessionizer` | 3-11 | Search paths `~/Github`, `~/Codes`, `~/College`, `~/Downloads`, `~/Pictures/*` |
| `tmux/.tmux.conf` | 30-33 | Jump keys for `~/Github`, `~/College`, `~/Codes`, `~/Downloads` |
| `tmux/.tmux.conf` | 36 | `$HOME/.cargo/bin/hopes` |
| `dunst/.config/dunst/dunstrc` | 21 | `/usr/share/icons/Papirus-Dark/32x32/` |
| `nvim/.config/nvim/lua/plugins/liveserver.lua` | 6, 8 | Port 6767, browser `brave browser` |
| `nvim/.config/nvim/lua/plugins/markdown.lua` | 14 | Port 8081 |
| `nvim/.config/nvim/lua/plugins/ipynb-peek.lua`, `md-peek.lua` | 4 | Local dev path `~/Github/...` (used only when `use_local_dev = true`) |
| `nvim/.config/nvim/lua/callo/set.lua` | 37 | `shell = "/bin/bash"` |
| `git/.gitconfig` | 3 | Email `carlosranara0@gmail.com` |
| `git/.gitconfig` | 6 | `credential.helper = store` saves tokens in plain text in `~/.git-credentials` |
| `rofi/.config/rofi/themes/*.rasi` | font line | `Cartograph CF 12`, not installed. These themes are unused |
| `extras/g14-power/g14-power` | 867, 978 | `pacman` hints. Tool is for an ASUS G14, not the CF-SV7 |

## Design tradeoffs kept

| Item | Reason |
| --- | --- |
| `nvim/.config/nvim/lua/callo/remap.lua:23,32` | `<leader>s` and `<leader>j` are prefixes of spell (`<leader>ss`) and iron.nvim (`<leader>j*`) keys, so they wait for `timeoutlen`. Kept to avoid changing muscle memory |
| zsh and fish duplicate aliases and env | Different languages; no shared file format |
| `fconv` and `git-purge` duplicate the `die`, `info`, `success` helpers | Scripts stay standalone and portable |
| `discord/nocturnal-mod-old.theme.css` | Imports remote CSS from `xcruxiex.github.io` and `discordstyles.github.io`. Needed by the theme |
| `picom/.config/picom/picom.conf` | Not started by i3. Suspected cause of extreme Brave lag on the CF-SV7 (`backend = "glx"`, `vsync = true`, Intel UHD 620); not confirmed, the lag also went away after a restart. Kept as an opt-in config |
| i3 reload runs `polybar/launch.sh` (`exec_always`) | Running `launch.sh` by hand at the same moment can start two bars. Run it again to fix |
