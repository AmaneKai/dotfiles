# Troubleshooting

Symptom, cause, fix. Details for CF-SV7 items are in `docs/hardware-cf-sv7.md`.

## Session and input

| Symptom | Cause | Fix |
| --- | --- | --- |
| Circular scroll does nothing | Wayland or libinput session, or X not restarted | Use X11 with the synaptics driver. Log out and `startx` again. Check `synclient -l \| grep CircularScrolling` |
| MinSpeed, MaxSpeed, AccelFactor, CircScrollDelta have no effect | Decimal options are ignored in xorg.conf | Set them with `synclient` from the i3 config. See `docs/hardware-cf-sv7.md` |
| F4, F5, F6 do nothing in i3 | They arrive as ACPI events, not X keys | Handle them with acpid rules. See `docs/hardware-cf-sv7.md` |
| acpid rule runs but audio does not change | acpid runs as root and cannot reach your PipeWire | Run the action as your user with `XDG_RUNTIME_DIR=/run/user/<UID>` |
| acpid rule with a percent value breaks | acpid expands `%` | Write `%%` in the rule file |
| Mute key toggles several times per press | Key fires several ACPI events | Debounce with a `flock` script |
| acpid ignores new rules after restart | Old acpid process still running | `sudo systemctl stop acpid && sudo pkill -9 acpid; sudo systemctl start acpid` |
| `system/install.sh` prints `done` but F-keys still dead | `system/etc/acpi/` is missing from the repo; errors are hidden | Add the files. See `docs/hardware-cf-sv7.md` |
| Japanese input never appears | Nothing in the repo starts fcitx5 or sets IM variables | Set the four IM variables in `~/.xinitrc`. Start fcitx5 via its XDG autostart file (`dex`) or run `fcitx5 -d` |
| Wrong keyboard layout in X | X11 keymap not set | `sudo localectl set-x11-keymap jp jp106` |

## Lock screen

| Symptom | Cause | Fix |
| --- | --- | --- |
| `$mod+u` or suspend does not lock | `lock.sh` uses i3lock-color options; plain `i3lock` exits | Install i3lock-color (Arch AUR `i3lock-color`, others from source) |
| Lock screen is not blurred, or lock fails | `maim` or Python Pillow missing | Install maim and Pillow. NumPy is optional (vignette only) |

## Bar and desktop

| Symptom | Cause | Fix |
| --- | --- | --- |
| No battery module in polybar | Battery names differ per machine | CF-SV7 uses `BAT1` and `AC`. Check `ls /sys/class/power_supply` |
| Polybar is the small 28 px bar on the laptop screen | `launch.sh` expects output `eDP`; actual is `eDP-1` | Known issue. Check `xrandr \| grep ' connected'` |
| Polybar logs an error for `spinner` | `format = <output>` is not a valid tag | Remove `spinner` from `modules-right` |
| Polybar warns about `tray-position` | Deprecated in polybar 3.7 | Known issue. Use the `internal/tray` module instead |
| Black background | Wallpaper not in repo | Place `~/Downloads/png/eclipse.png` |
| autorandr runs but nothing changes | No `laptop` profile saved | `autorandr --save laptop` |
| `$mod+f` does nothing | `pcmanfm` not installed | Install pcmanfm |
| Audio switch has no sound | `mpv` not installed | Install mpv |
| `$mod+Shift+d` says earbuds not connected | AirPods MAC hardcoded in `audio-switch.sh:13` | Edit the card name for your device |
| Network menu ignores the rose-pine theme | `nmdmenu` config calls `rofi` without `-theme` | Known issue |

## Bluetooth

| Symptom | Cause | Fix |
| --- | --- | --- |
| No adapter: no `/sys/class/bluetooth`, no bluetooth in `rfkill list` | Adapter disabled at firmware level | Check the BIOS wireless / Bluetooth toggle. Then `sudo systemctl enable --now bluetooth` |

## Audio, power, video

| Symptom | Cause | Fix |
| --- | --- | --- |
| Package manager refuses `pipewire-pulse` | Conflicts with `pulseaudio` | Remove `pulseaudio`, keep `pipewire-pulse` |
| `pactl` not found | Client tools not installed | Arch `libpulse`, Fedora and Debian `pulseaudio-utils` |
| Power profile changes are overridden | TLP running with power-profiles-daemon | Remove TLP. Keep power-profiles-daemon and thermald |
| `vainfo` shows the i965 driver | Old driver installed next to iHD | Remove `libva-intel-driver` (Arch) or `i965-va-driver` (Debian family) |
| Fedora: power-profiles-daemon will not install | `tuned-ppd` conflicts | `sudo dnf swap tuned-ppd power-profiles-daemon` |

## Shell

| Symptom | Cause | Fix |
| --- | --- | --- |
| zsh prints `no such file or directory: /home/amane/.deno/env` | `.zshrc:98` sources it unconditionally | Install deno with its installer, or accept the error. Known issue |
| zsh prints `command not found: zoxide` | `.zshrc:37` runs unconditionally | Install zoxide |
| `ls` prints an eza error about `--icons` | Old alias `eza --icons` breaks on newer eza | Repo already uses `--icons=auto`. Restow zsh and fish if an old copy is linked |
| Java tools fail, `JAVA_HOME` invalid | `.zshrc:94` and `config.fish:10` hardcode `java-26-openjdk` | Check `ls /usr/lib/jvm`. Known issue |
| Files in `~/Downloads` move on every new shell | `.zshrc:97` runs `organize-downloads` | Expected behavior of the config |
| `tmux-sessionizer` not found | Repo not at `~/Dotfiles` | Clone to `~/Dotfiles`. The path is hardcoded |

## tmux

| Symptom | Cause | Fix |
| --- | --- | --- |
| Mouse selection does not reach the system clipboard | Only the `MouseDragEnd1Pane` copy-mode-vi binding pipes to `xclip` | Install xclip. Select with the mouse in copy mode |
| `prefix t` popup closes at once | `~/.cargo/bin/hopes` missing | Install hopes (source UNVERIFIED) |

## Neovim

| Symptom | Cause | Fix |
| --- | --- | --- |
| lazy.nvim errors on plenary or rockspec | luarocks missing | Install luarocks, or set `rocks = { enabled = false }` in `lazy.setup` |
| nvim-treesitter fails to build parsers | Neovim below 0.12 or tree-sitter-cli below 0.26.1 | Install newer versions. See `docs/packages.md` |
| plenary appears twice in `:Lazy` | Declared as `plenary` and as `nvim-lua/plenary.nvim` | Known issue |
| `<leader>f` formats nothing | Formatter missing (ruff, prettier, eslint_d) | Install per `docs/packages.md` |
| live-server build fails | `npm install -g` needs a writable prefix | `npm config set prefix ~/.npm-global` |
| Java LSP uses the wrong JDK after opening a Kotlin file | `kotlin.lua:22` sets `JAVA_HOME` for the session | Restart Neovim. Known issue |

## Stow

| Symptom | Cause | Fix |
| --- | --- | --- |
| `existing target is neither a link nor a directory` | Real file at the target | Move the file away, then stow |
| Conflict on a dangling symlink | Old link to a moved or deleted repo | Remove the link, then stow |
| Links broken after moving or renaming the repo | Links are relative to the old path | `stow -D <pkgs>` first, then move, then `stow <pkgs>` |
| Editing a stowed file with `sed -i` replaced the link | `sed -i` writes a new file | Use `sed -i --follow-symlinks` |
| `stow scripts` aborts: `source is an absolute symlink` | Ignored `scripts/.local/bin/claude` link exists in the checkout | `stow --ignore=claude scripts` |
| `~/g14-power` appears in home | `scripts/g14-power` is inside the stow package | `stow -D scripts && stow --ignore=g14-power --ignore=claude scripts` |
| New files show up inside the repo | Stow folded a whole directory (for example `~/.local`) into a link | `stow -D <pkg>`, `mkdir -p` the real directory, stow again |

## KDE

| Symptom | Cause | Fix |
| --- | --- | --- |
| High CPU from `baloo_file` | Baloo indexer | `balooctl6 disable` |
| Ghostty has no native titlebar | Client-side decorations | Add `window-decoration = server` to the ghostty config |
| Ghostty fails with `Remote peer disconnected` | systemd user unit type | Add a systemd override with `Type=notify` (unit name UNVERIFIED) |
| Fedora: `plasma-workspace-x11` install hits a file conflict | Old `kmime` package | Remove the old `kmime` package first |
