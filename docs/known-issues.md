# Known issues

Bugs and hardcoded values in configs. Not fixed. Found 2026-09-28 on branch `linux`; line numbers refer to that state.

## Bugs

| File | Line | Issue |
| --- | --- | --- |
| `i3lock/bin/lock.sh` | 10-39 | Uses i3lock-color options (`--clock`, `--time-str`, `--ring-color`, ...). Plain `i3lock` 2.16 rejects them, prints its syntax line and exits, so the screen does not lock. Install i3lock-color. |
| `polybar/.config/polybar/launch.sh` | 4, 17 | `LAPTOP_OUTPUT="eDP"` is matched exactly. On this laptop the output is `eDP-1`, so the internal panel is treated as external and the `monitor` bar (28 px) starts instead of the `laptop` bar (36 px). |
| `polybar/.config/polybar/config.ini` | 37, 131-138 | `spinner` is still in `modules-right`. Its `format = <output>` is not a valid tag for `custom/script` (valid: `<label>`). Reported to fail on newer polybar. Runtime error on 3.7.2 UNVERIFIED. |
| `polybar/.config/polybar/config.ini` | 41-43 | `tray-position`, `tray-padding`, `tray-background` are deprecated since polybar 3.7 in favor of the `internal/tray` module. |
| `zsh/.zshrc` | 94 | `JAVA_HOME=/usr/lib/jvm/java-26-openjdk`. Arch `jdk-openjdk` is now 27 and installs `java-27-openjdk`. The path does not exist on the audited machine. |
| `fish/.config/fish/config.fish` | 10 | Same `java-26-openjdk` hardcode. |
| `zsh/.zshrc` | 98 | `. "/home/amane/.deno/env"` runs unconditionally. Errors on every shell start when deno is not installed with its installer. |
| `zsh/.zshrc` | 37 | `eval "$(zoxide init zsh)"` runs unconditionally. Errors when zoxide is missing. fish guards this (`config.fish:54`). |
| `zsh/.zshrc` | 9 | Sources oh-my-zsh unconditionally. Errors when `~/.oh-my-zsh` is missing. |
| `zsh/.zshrc` | 97 | Runs `organize-downloads --quiet` on every shell start, moving files in `~/Downloads`. Errors when `scripts` is not stowed. |
| `scripts/.local/bin/organize-screenshots` | 5-11 | Creates `Screenshots/` and `Recordings/` but moves into lowercase `screenshots/` and `recordings/`. Those do not exist, so each `mv` renames the file to `~/Pictures/screenshots` and the next one overwrites it. |
| `scripts/.local/bin/organize-screenshots` | 13-16 | Moves every other file in `~/Pictures` into `other/`, including the wallpaper if kept there. |
| `system/install.sh` | 4-6 | Edits and chmods `/etc/acpi/mute-debounced.sh` and `/etc/acpi/events/*`, but no `system/etc/acpi/` exists in the repo. Errors are sent to `/dev/null` and the script prints `done` anyway. |
| `system/install.sh` | 3 | `sudo cp -r etc/. /etc/` overwrites existing files without backup. |
| `system/install.sh` | 6 | Restarts acpid even if acpid is not installed. Error is hidden. |
| `nvim/.config/nvim/lua/plugins/init.lua` | 3-4 | Declares plenary with `name = "plenary"`. harpoon and telescope depend on `nvim-lua/plenary.nvim`, so lazy.nvim installs it twice (`lazy-lock.json` has both `plenary` and `plenary.nvim`). |
| `nvim/.config/nvim/lua/plugins/kotlin.lua` | 21-22 | Sets `vim.env.JAVA_HOME` for the whole Neovim session when a Kotlin file opens. jdtls and gradle started later in that session use the Kotlin LSP's bundled JBR. |
| `nvim/.config/nvim/lua/plugins/lsp.lua` | 15-161 | Uses `mason-lspconfig` `handlers` and `require("lspconfig")[name].setup`. Newer mason-lspconfig (v2) removed `handlers` and nvim 0.11+ prefers `vim.lsp.config`. Whether the pinned commit still works: UNVERIFIED. |
| `nvim/.config/nvim/lua/plugins/lsp.lua` | 135-146 | Has a `gopls` handler but `gopls` is not in `ensure_installed`. |
| `scripts/.local/bin/fconv` | 26 | Missing-dependency message says `brew install` on Linux too. |
| `scripts/.local/bin/fconv` | 70-72 | An unknown option runs `shift` twice, so it also swallows the next argument. |
| `scripts/.local/bin/fconv` | 126-128 | `ogg` and `m4a` outputs are encoded with libmp3lame. The ogg muxer does not take MP3; failure UNVERIFIED. |
| `nvim/.config/nvim/lua/plugins/python.lua`, `ipynb-peek.lua` | python 15-96, ipynb-peek 23-27 | iron.nvim sets global `<leader>jo`, `<leader>jc`, `<leader>jr`, `<leader>jR`; ipynb-peek uses the same keys. Which wins in `.ipynb` buffers: UNVERIFIED. |
| `nvim/.config/nvim/lua/callo/remap.lua` | 31, 41 | `<leader>s` and `<leader>j` are prefixes of `<leader>ss`, `<leader>sa`, `<leader>sc` (spell) and `<leader>j*` (iron), so they wait for `timeoutlen` before running. |
| `scripts/.local/bin/git-purge` | 45 | `grep -q "$BRANCH"` is a substring match. `feat` matches `feature-x`. |
| `ghostty/.config/ghostty/config` | 5 | `theme = Rose Pine ` has a trailing space. Effect UNVERIFIED. |
| `.gitignore` + `scripts/.local/bin/claude` | 2 | The ignored `claude` file is an absolute symlink. When it exists, `stow scripts` aborts with "source is an absolute symlink". |

## Hardcoded values

| File | Line | Value |
| --- | --- | --- |
| `zsh/.zshrc` | 25 | `$HOME/Dotfiles/bin` in PATH. Repo must live at `~/Dotfiles`. |
| `fish/.config/fish/config.fish` | 16 | `$HOME/Dotfiles/bin` in PATH. |
| `tmux/.tmux.conf` | 34-41 | `~/Dotfiles/bin/tmux-sessionizer`, plus `~/Github`, `~/College`, `~/Codes`, `~/Downloads`, `~/Dotfiles`. |
| `tmux/.tmux.conf` | 43-44 | `$HOME/.cargo/bin/hopes`. `t` and `T` run the same command. |
| `zsh/.zshrc` | 88 | `/home/amane/.bun/_bun` (duplicate of lines 81-82). |
| `zsh/.zshrc` | 93 | `/home/amane/.opencode/bin`. |
| `zsh/.zshrc` | 98 | `/home/amane/.deno/env`. |
| `bin/tmux-sessionizer` | 11-20 | Search paths, including `~/i3-dotfiles/` (old repo name). |
| `i3/.config/i3/config` | 23 | Wallpaper `~/Downloads/png/eclipse.png`. Not in repo. |
| `i3/.config/i3/config` | 53 | autorandr profile `laptop`. Profile not in repo; create with `autorandr --save laptop`. |
| `i3/.config/i3/config` | 44-45 | `wezterm`, `pcmanfm`. |
| `i3/.config/i3/scripts/audio-switch.sh` | 11-13, 19, 25 | FIFINE K690 sink name and AirPods card `bluez_card.14_7A_E4_DD_CA_26`. |
| `polybar/.config/polybar/config.ini` | 192-193 | `BAT1` and `AC`. Correct for CF-SV7. Other laptops differ. |
| `dunst/.config/dunst/dunstrc` | 24 | `/usr/share/icons/Papirus-Dark/32x32/`. |
| `system/etc/X11/xorg.conf.d/70-synaptics.conf` | 12-15 | Touchpad edge values for the CF-SV7 circular pad. |
| `nvim/.config/nvim/lua/plugins/liveserver.lua` | 6, 8 | Port 6767, browser `brave browser`. |
| `nvim/.config/nvim/lua/plugins/markdown.lua` | 14 | Port 8081. |
| `nvim/.config/nvim/lua/plugins/ipynb-peek.lua`, `md-peek.lua` | 4 | Local dev path `~/Github/...` (only when `use_local_dev = true`). |
| `nvim/.config/nvim/lua/callo/set.lua` | 40 | `shell = "/bin/bash"`. |
| `git/.gitconfig` | 3, 6 | Email `carlosranara0@gmail.com`. `credential.helper = store` saves tokens in plain text. |
| `rofi/.config/rofi/themes/*.rasi` | 15 (dawn: 17) | Font `Cartograph CF 12`. Not installed by any doc. Themes are unused by the scripts. |
| `scripts/g14-power/g14-power` | 867, 978 | `pacman` hints. Tool is for an ASUS G14, not the CF-SV7. |

## Repo structure

| Item | Issue |
| --- | --- |
| `scripts/g14-power/` | Inside the `scripts` stow package, so `stow scripts` links `~/g14-power`. Use `--ignore=g14-power`. |
| `scripts/.local/bin/uv`, `uvx` | 63 MB and 344 KB vendored binaries in git. |
| `discord/` | Not a stow package. The theme imports remote CSS from `xcruxiex.github.io` and `discordstyles.github.io`. |
| `system/etc/acpi/` | Missing. Referenced by `system/install.sh`. |
| `~/.xinitrc` | Not in repo. Starts i3 and sets fcitx env vars on the audited machine. |
| fcitx5 | No config, autostart, or env vars in repo. |
| synclient decimal options | Not in repo. Neither `70-synaptics.conf` nor the i3 config sets MinSpeed, MaxSpeed, AccelFactor, CircScrollDelta. |
| picom | Not referenced anywhere in the repo. |
| `nmdmenu/.config/networkmanager-dmenu/config.ini` | Sets `dmenu_command = rofi` with no `-theme`. The rose-pine theme is not applied. |
