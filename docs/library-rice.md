# Library rice (Hyprland)

Hyprland 0.57 Lua config themed after the Yorushika "Fireworks Beneath My Shoes" frames. Square corners, 1px borders, a double-rule frame on every panel, Shippori Mincho headings and JetBrainsMono Nerd Font for terminals.

Stow order: `hypr hypridle hyprlock hyprpaper quickshell kitty zathura fuzzel kdetheme mako fastfetch`. Always stow before editing `hyprland.lua`, because Hyprland reloads on save and a missing `conf.*` module aborts the whole config.

## Layout

| Path | Role |
| --- | --- |
| `hypr/.config/hypr/hyprland.lua` | thin entry that requires `conf.*` |
| `hypr/.config/hypr/conf/` | env, monitors, look, input, binds, rules, autostart, palette |
| `hypr/.config/hypr/scripts/` | `osd.sh`, `wallpaper.sh`, `restart-shell.sh` |
| `quickshell/.config/quickshell/library/` | the shell: `bar`, `notifs`, `osd`, `launcher`, `components`, `Theme.qml` |

## Palette

`palette/palette.json` is the single source of colours and fonts. `node palette/build.js` regenerates `Theme.qml`, `conf/palette.lua` and the kitty, zathura, fuzzel, mako and hyprlock configs from `palette/templates/`; edit the palette or a template, never the generated file. Template tokens: `{{name}}` is `#hex`, `{{name:bare:AA}}` bare hex with alpha, `{{name:rgba:AA}}` hyprlang `rgba()`, `{{name:css:0.5}}` CSS `rgba()`. `node palette/render.test.js` checks the renderer.

## Cursor

`cursor-src/generate.py` draws the `Library` XCursor theme (cream arrow, terracotta pointer, I-beam) from the palette and writes it into the `cursor` stow package; other cursor shapes inherit from `breeze_cursors`. Regenerate with `python3 cursor-src/generate.py`, then `stow -t ~ cursor`.

## Textures

There is no hand-drawn art, so `texture-src/generate.py` makes up for it: seeded paper grain with fibres, a wobbling double-ink rule for the bar edge, and inked corner marks, all coloured from the palette and written to `quickshell/.../library/assets/`. `Frame` tiles the grain and draws the corners (`ornamented: false` turns them off for small cards). Regenerate with `python3 texture-src/generate.py`.

## Qt apps

`kvantum-src/generate.py` builds the `Library` Kvantum theme from KvFlat (needs the `kvantum` package): palette colours, square corner pieces, and the paper grain embedded as the window, toolbar, dock and status bar background. `QT_STYLE_OVERRIDE=kvantum` in `conf/env.lua` selects it and the KDE colour scheme still covers everything Kvantum does not. Item views (file lists) stay flat because Kvantum cannot texture them. Regenerate with `python3 kvantum-src/generate.py`, then `stow -t ~ kvantum`. Apps keep the style they started with, so relaunch them after changes.

## Shell modules

Each module owns its state in a `Controller.qml` singleton and exposes an `IpcHandler`; nothing reaches into another module's internals. Pure logic lives in `.js` libraries and is tested with node:

```
node quickshell/.config/quickshell/library/tests/launcher.test.js
node quickshell/.config/quickshell/library/tests/bar.test.js
```

| IPC target | Functions |
| --- | --- |
| `launcher` | `toggle`, `open`, `close`, `search(text, drawer)` |
| `bar` | `toggle(name)` with `network`, `bluetooth`, `sound`, `player`, `power`, `notifications`, `calendar`, `controls`, `clipboard`, `wallpapers`; `close` |
| `overview` | `toggle`, `close` |
| `screenshot` | `region`, `annotate`, `cancel` |
| `lock` | `lock`, `isLocked` |
| `osd` | `set(kind, percent, muted)` |
| `notifications` | `dismissAll`, `clearHistory` |

Call with `qs -c library ipc call <target> <function> [args]`.

## Lock screen

`lock/` is a `WlSessionLock` with a PAM `password.conf` (`pam_unix` only). `hypridle` and `Super+L` call it and fall back to hyprlock when the shell is down; `misc.allow_session_lock_restore` lets a replacement locker take over if it crashes. Starting the shell with `QS_LOCK_TEST_SECONDS=8` makes every lock release itself after that many seconds, for testing without typing a password.

## Keys

`Super+Space` launcher, `Super+D` fuzzel, `Super+L` lock, `Super+Shift+S` region screenshot to clipboard, `Super+Shift+V` clipboard history, `Super+Shift+W` next wallpaper, `Super+Shift+A` annotate a screenshot with satty, `Super+\`` workspace overview.

## Quirks

- The running shell process is named `quickshell`, not `qs`: restart it with `pkill -x quickshell` then start `qs -c library --no-duplicate`. Killing only `qs` leaves the old shell running and stacks a second bar.
- Tray icons open a themed menu panel (`bar tray N` over IPC) instead of a native popup.
- Quickshell needs `WAYLAND_DISPLAY` set for `ipc`; a function named `show` cannot be called, hence `osd set`.
- New `.qml` files need a full `qs` restart; hot reload only covers existing files.
- Colors in QML are `#AARRGGBB`.
- `QS_ICON_THEME=breeze-dark` is set in `conf/env.lua` so notification icons resolve.
- Panels are drawn fully opaque; layer blur on `qs-*` was not reliable.
- Notifications: mako ships a D-Bus activation file, so it grabs `org.freedesktop.Notifications` whenever the name is free. The `dbus` package overrides it with one that starts Quickshell instead.
- Waybar segfaulted on monitor hotplug, which is why the bar is QML. The `waybar`, `eww` and `launcher` (rofi) packages are unstowed and kept in the repo for reference; `mako` stays as the fallback notifier and `fuzzel` as the launcher fallback.
- `kded6` can rewrite the tracked `gtk-3.0`/`gtk-4.0` settings through the stow symlinks; restore them with `git checkout`.
- Never use `stow --adopt`.
