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
| `system/install.sh` prints `skipped acpid setup` | `system/etc/acpi/` is missing from the repo | Add the files. See `docs/hardware-cf-sv7.md` |
| Japanese input never appears | fcitx5 not running, or session not started through `~/.xinitrc` | Stow `xinit` and use `startx`. fcitx5 starts from its XDG autostart file via `dex`; otherwise run `fcitx5 -d` |
| Wrong keyboard layout in X | X11 keymap not set | `sudo localectl set-x11-keymap jp jp106` |

## Lock screen

| Symptom | Cause | Fix |
| --- | --- | --- |
| Lock screen shows a plain blurred image, no clock or ring | Plain `i3lock` installed; `lock.sh` fell back | Install i3lock-color (Arch AUR `i3lock-color`, others from source) |
| Lock screen is not blurred, or lock fails | `maim` or Python Pillow missing | Install maim and Pillow. NumPy is optional (vignette only) |

## Bar and desktop

| Symptom | Cause | Fix |
| --- | --- | --- |
| No battery module in polybar | Battery names differ per machine | CF-SV7 uses `BAT1` and `AC`. Check `ls /sys/class/power_supply` |
| Black background | Wallpaper not in repo | Place `~/Downloads/png/eclipse.png` |
| autorandr runs but nothing changes | No `laptop` profile saved | `autorandr --save laptop` |
| `$mod+f` does nothing | `pcmanfm` not installed | Install pcmanfm |
| Audio switch has no sound | `mpv` not installed | Install mpv |
| `$mod+Shift+d` says earbuds not connected | No Bluetooth audio card in `pactl list cards short` | Connect the headset first (`$mod+Shift+b`) |
| `$mod+Shift+f` says mic not connected | No sink with `FIFINE` in its name | Plug in the mic, check `pactl list sinks short` |

## Bluetooth

| Symptom | Cause | Fix |
| --- | --- | --- |
| `$mod+Shift+b` shows only "Turn Bluetooth On" | No controller; `bluetoothctl show` timed out after 2 s | See the next row |
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
| `ls` prints an eza error about `--icons` | Old alias `eza --icons` breaks on newer eza | Repo already uses `--icons=auto`. Restow zsh and fish if an old copy is linked |
| Files in `~/Downloads` move on every new shell | `.zshrc:97` runs `organize-downloads` | Expected behavior of the config |

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
| `<leader>f` formats nothing | Formatter missing (ruff, prettier, eslint_d) | Install per `docs/packages.md` |
| live-server build fails | `npm install -g` needs a writable prefix | `npm config set prefix ~/.npm-global` |

## Stow

| Symptom | Cause | Fix |
| --- | --- | --- |
| `existing target is neither a link nor a directory` | Real file at the target | Move the file away, then stow |
| Conflict on a dangling symlink | Old link to a moved or deleted repo | Remove the link, then stow |
| Links broken after moving or renaming the repo | Links are relative to the old path | `stow -D <pkgs>` first, then move, then `stow <pkgs>` |
| Editing a stowed file with `sed -i` replaced the link | `sed -i` writes a new file | Use `sed -i --follow-symlinks` |
| New files show up inside the repo | Stow folded a whole directory (for example `~/.local/bin`) into a link | `stow -D <pkg>`, move non-repo files out, `mkdir -p` the real directory, stow again |

## KDE

| Symptom | Cause | Fix |
| --- | --- | --- |
| High CPU from `baloo_file` | Baloo indexer | `balooctl6 disable` |
| Ghostty has no native titlebar | Client-side decorations | Add `window-decoration = server` to the ghostty config |
| Ghostty fails with `Remote peer disconnected` | systemd user unit type | Add a systemd override with `Type=notify` (unit name UNVERIFIED) |
| Fedora: `plasma-workspace-x11` install hits a file conflict | Old `kmime` package | Remove the old `kmime` package first |
