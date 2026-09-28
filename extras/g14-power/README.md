# g14-power

One power-policy command for an ASUS G14 on CachyOS/Arch. It replaces the
uploaded collection of one-off fix scripts with a single source of truth.

## What owns what

| Control | Owner |
| --- | --- |
| Platform power profile / ASUS fan profile integration | `power-profiles-daemon` |
| CPU boost and HDA audio power saving | `g14-power` |
| NVIDIA graphics mode and ASUS hardware gate | `supergfxd` |
| AC plug/unplug event serialization | `systemd` |

The tool never removes the NVIDIA PCI device, never writes `dgpu_disable`,
never runs blanket `powertop --auto-tune`, never changes every PCI/USB device,
and never edits `supergfxd.conf` unless the daemon is broken or you explicitly
request `--reset-supergfxd`.

## Install and recover

```bash
chmod +x g14-power
sudo ./g14-power install
g14-power status
g14-power doctor
```

The installer disables and backs up the known legacy installed files before it
starts the new service. It does not delete the original scripts in your project
folder and it never reboots the laptop.

If `status` still reports `timeout/error` for `supergfxctl`:

```bash
sudo g14-power repair --reset-supergfxd
```

That explicit command backs up `/etc/supergfxd.conf`, writes the documented
baseline configuration, restarts `supergfxd`, and reapplies the current AC or
battery policy.

## Daily use

```bash
g14-power                 # status TUI; safe, does not run nvidia-smi
sudo g14-power auto       # detect AC/battery and apply policy
sudo g14-power battery    # low-power CPU + Integrated GPU request
sudo g14-power balanced   # balanced CPU + Hybrid GPU request
sudo g14-power gaming     # performance CPU + Hybrid GPU request
g14-power doctor          # conflicts, pending action, open GPU clients
```

Switching between `Hybrid` and `Integrated` normally requires logging out of
the graphical session. The command reports that pending action rather than
claiming that the GPU is already off. After the logout, `Integrated` makes the
dGPU unavailable. In `Hybrid`, runtime D3 can suspend it when nothing is using
it.

Edit `/etc/g14-power.conf` to change the automatic profiles. For example, if
you prefer runtime suspension without logout-driven mode changes:

```bash
BATTERY_GPU_MODE="Hybrid"
BALANCED_GPU_MODE="Hybrid"
```

Use `Keep` for any profile whose GPU mode should never be changed.

## Why the old setup became busy

Several old scripts overwrote `/usr/local/bin/g14_power_auto.sh` with different
versions. Others independently edited `/etc/supergfxd.conf`, wrote the ASUS
hardware gate, removed `0000:01:00.0` from PCI, and restarted `supergfxd` while
another mode transition was pending. That gave the same GPU multiple owners.

There were also correctness problems: fixed PCI addresses, broad AC-device
globs, a malformed `pending_mode` replacement, unbounded global PCI/USB power
changes, hidden errors, automatic reboot, and a diagnosis script that labeled
every timeout or command failure as “Pending / Busy.”

## Uninstall

```bash
sudo g14-power uninstall
sudo g14-power uninstall --purge   # also remove /etc/g14-power.conf
```

Legacy backups remain under `/var/lib/g14-power/backups/` so recovery stays
possible.

## Development check

```bash
bash -n g14-power
./tests/smoke.sh
```

## Upstream references

- <https://asus-linux.org/manual/supergfxctl-manual/>
- <https://asus-linux.org/guides/arch-guide/>
