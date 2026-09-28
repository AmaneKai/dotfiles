# CF-SV7 hardware

Setup specific to the Panasonic Let's Note CF-SV7. Run after the install guide for your distro.

## Hardware

| Part | Value | Source |
| --- | --- | --- |
| CPU | Intel Core i5-8350U | owner |
| GPU | Intel UHD 620 (Kaby Lake-R GT2, `8086:5917`) | `lspci -nn` |
| Wi-Fi | Intel Wireless 8265 (`8086:24fd`) | `lspci -nn` |
| Screen | 1920x1200 (16:10), output `eDP-1` | `xrandr` |
| Keyboard | JIS, jp106 | owner, `/etc/X11/xorg.conf.d/00-keyboard.conf` |
| Battery, AC | `BAT1`, `AC` | `/sys/class/power_supply` |
| Session | X11 only (circular scroll needs synaptics) | owner |

## Firmware

| Distro | Package for Wi-Fi 8265 |
| --- | --- |
| Arch | linux-firmware-intel (pulled in by linux-firmware) |
| Fedora | iwlwifi-mvm-firmware |
| Debian | firmware-iwlwifi (non-free-firmware component) |
| Ubuntu, Mint | linux-firmware |

## Keyboard

Arch, Fedora:

```bash
sudo localectl set-keymap jp106
sudo localectl set-x11-keymap jp jp106 "" terminate:ctrl_alt_bksp
```

Debian family: `sudo dpkg-reconfigure keyboard-configuration`, pick Japanese 106-key.

## Touchpad circular scroll

| Requirement | Detail |
| --- | --- |
| Session | X11. libinput and Wayland have no circular scroll |
| Driver | Arch `xf86-input-synaptics`, Fedora `xorg-x11-drv-synaptics-legacy`, Debian family `xserver-xorg-input-synaptics` |
| Config | `system/etc/X11/xorg.conf.d/70-synaptics.conf`, copied by `system/install.sh` |
| Reload | Full X restart. Log out of i3 and run `startx` again. i3 restart is not enough |
| Decimal options | `MinSpeed`, `MaxSpeed`, `AccelFactor`, `CircScrollDelta` are ignored in xorg.conf. Set them with `synclient` at runtime |

The repo does not set the decimal options anywhere. To add them, put one line in the i3 config (values UNVERIFIED, tune by hand):

```text
exec_always --no-startup-id synclient MinSpeed=<value> MaxSpeed=<value> AccelFactor=<value> CircScrollDelta=<value>
```

Check:

```bash
synclient -l | grep -E 'CircularScrolling|CircScrollTrigger|CircularPad|MinSpeed|MaxSpeed|AccelFactor|CircScrollDelta'
```

Expected: `CircularScrolling = 1`, `CircularPad = 1`, `CircScrollTrigger = 0`.

## Function keys F4, F5, F6

| Fact | Detail |
| --- | --- |
| Delivery | ACPI events, not X keysyms. i3 `bindsym` cannot see them |
| Handler | acpid rules in `/etc/acpi/events/` |
| Percent sign | Write `%` as `%%` inside acpid rule files |
| User context | acpid runs as root. Run the action as your user with `XDG_RUNTIME_DIR=/run/user/<UID>` or PipeWire is unreachable |
| Mute key | Fires several events per press. Needs a `flock` debounce script |
| Restart | If `systemctl restart acpid` does not pick up rules: `sudo systemctl stop acpid && sudo pkill -9 acpid; sudo systemctl start acpid` |
| Repo state | `system/install.sh` expects `system/etc/acpi/mute-debounced.sh` and `system/etc/acpi/events/*` with `__USER__` and `__UID__` placeholders. Those files are not in the repo |
| Key functions | Which action F4, F5, F6 perform: UNVERIFIED |

Capture the event strings:

```bash
sudo pacman -S --needed acpid   # or dnf / apt
sudo systemctl enable --now acpid
acpi_listen
```

Press each key and copy the printed line. To restore the missing files, add them under `system/etc/acpi/` with `__USER__` and `__UID__` in place of your user name and UID, then run `system/install.sh`. Template (not from the repo, UNVERIFIED):

`system/etc/acpi/events/cf-sv7-mute`:

```text
event=<line from acpi_listen>
action=/etc/acpi/mute-debounced.sh
```

`system/etc/acpi/mute-debounced.sh`:

```sh
#!/bin/sh
exec 9>/run/acpi-mute.lock
flock -n 9 || exit 0
runuser -u __USER__ -- env XDG_RUNTIME_DIR=/run/user/__UID__ wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
sleep 0.3
```

## Bluetooth

On the audited Arch install the adapter is absent: no `/sys/class/bluetooth`, no bluetooth entry in `rfkill list`, no Intel `8087:` device in `lsusb`.

| Step | Command or action |
| --- | --- |
| Check adapter | `ls /sys/class/bluetooth; rfkill list; lsusb \| grep -i 8087` |
| If nothing shows | Check the BIOS wireless / Bluetooth toggle |
| After it shows | `sudo systemctl enable --now bluetooth` |

`i3/.config/i3/scripts/audio-switch.sh:13` hardcodes an AirPods card MAC. `bluetooth-menu.sh` does not hardcode a MAC.

## Polybar

| Item | Value |
| --- | --- |
| Battery | `battery = BAT1`, `adapter = AC` (`polybar/.config/polybar/config.ini:192-193`) |
| Output | `eDP-1`. `launch.sh` expects `eDP` and starts the wrong bar. See `docs/known-issues.md` |
| Spinner | `format = <output>` is invalid. Remove `spinner` from `modules-right` to disable |
| Tray | `tray-*` keys are deprecated since polybar 3.7 |

## Video decode

Install only the iHD driver. Do not install `libva-intel-driver` (Arch) or `i965-va-driver` (Debian family) alongside it.

```bash
vainfo 2>&1 | grep -i 'driver version'
```

Expected: `Intel iHD driver`.

## Power

| Use | Avoid |
| --- | --- |
| power-profiles-daemon, thermald | TLP together with power-profiles-daemon |

```bash
powerprofilesctl get
systemctl is-active thermald
```

## Audio

| Use | Avoid |
| --- | --- |
| pipewire, wireplumber, pipewire-pulse | the `pulseaudio` package (conflicts with pipewire-pulse) |

Configs call `wpctl` (i3 volume keys) and `pactl` (menus, polybar).

## Japanese input

Not configured by the repo. Needs fcitx5, the Mozc engine, and these variables before i3 starts (the audited `~/.xinitrc` sets the first three; `SDL_IM_MODULE` is missing there):

```sh
export GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx SDL_IM_MODULE=fcitx
```

Add Mozc in `fcitx5-configtool` after first login.

## KDE Plasma on this laptop

| Item | Detail |
| --- | --- |
| X11 session | Needed for synaptics. Fedora package `plasma-workspace-x11`. KDE plans to drop the X11 session in Plasma 6.8 (owner report) |
| kmime conflict | Installing `plasma-workspace-x11` on Fedora hit a file conflict. Fix: remove the old `kmime` package first |
| Baloo | CPU spikes. `balooctl6 disable` |
