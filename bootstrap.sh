#!/usr/bin/env bash
# One-command recovery for a fresh Arch/CachyOS + KDE Plasma (Wayland) install.
# Usage: ./bootstrap.sh [--dry-run] [--skip step[,step...]] [--only step[,step...]]
# Steps: packages aur stow installers system kde
# Safe to re-run. Run as your normal user; sudo asks for your password itself.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
STOW_PKGS=(fish ghostty git nvim tmux fastfetch scripts zsh kde)
WALLPAPER_NAME=anime_skull.png
FONT="Roboto Mono"

PACMAN_PKGS=(
  git stow base-devel curl tar unzip gzip
  zsh fish zoxide eza fzf yt-dlp gradle go bun deno jdk-openjdk nodejs npm rustup xdg-user-dirs
  tmux xclip wl-clipboard
  neovim tree-sitter-cli ripgrep fd luarocks ruff prettier eslint_d ipython gdb delve
  ffmpeg bc fastfetch ghostty opencode
  ttf-jetbrains-mono-nerd ttf-roboto-mono adobe-source-han-sans-jp-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme
  fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool
  networkmanager bluez bluez-utils
)
AUR_PKGS=(python-jupytext rose-pine-gtk-theme rose-pine-cursor)

DRY=0
SKIP=","
ONLY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY=1 ;;
    --skip) SKIP="$SKIP$2,"; shift ;;
    --only) ONLY=",$2,"; shift ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

log()  { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
note() { printf '    %s\n' "$*"; }
run()  { if [ "$DRY" = 1 ]; then printf '    [dry-run] %s\n' "$*"; else "$@"; fi; }
want() { if [ -n "$ONLY" ]; then [[ "$ONLY" == *",$1,"* ]] || return 1; fi; [[ "$SKIP" != *",$1,"* ]]; }
# write stdin to a file (user-owned)
put()  { if [ "$DRY" = 1 ]; then printf '    [dry-run] write %s\n' "$1"; cat >/dev/null; else mkdir -p "$(dirname "$1")"; cat >"$1"; fi; }
kw()   { run kwriteconfig6 "$@"; }

check_distro() {
  . /etc/os-release
  case " $ID $ID_LIKE " in
    *" arch "*|*" cachyos "*) ;;
    *) echo "This script supports Arch/CachyOS only (found: $ID)."
       echo "Follow docs/install-fedora.md or docs/install-debian.md instead."; exit 1 ;;
  esac
  [ "$(id -u)" -ne 0 ] || { echo "Run as your normal user, not root."; exit 1; }
}

step_packages() {
  log "Installing packages"
  run sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"
}

step_aur() {
  log "Building AUR packages"
  run mkdir -p "$HOME/aur"
  for p in "${AUR_PKGS[@]}"; do
    if pacman -Q "$p" >/dev/null 2>&1; then note "$p already installed"; continue; fi
    [ -d "$HOME/aur/$p" ] || run git clone -q "https://aur.archlinux.org/$p.git" "$HOME/aur/$p"
    if [ "$DRY" = 1 ]; then note "[dry-run] makepkg -si in ~/aur/$p"; else (cd "$HOME/aur/$p" && makepkg -si --noconfirm --needed); fi
  done
}

# Move real files that would block stow aside as *.pre-stow.
backup_conflicts() {
  local pkg f rel target
  for pkg in "${STOW_PKGS[@]}"; do
    while IFS= read -r -d '' f; do
      rel="${f#"$DOTFILES/$pkg/"}"
      [ "$(basename "$rel")" = jdtls ] && continue
      target="$HOME/$rel"
      [ -e "$target" ] || [ -L "$target" ] || continue
      case "$(readlink -f "$target")" in "$DOTFILES"/*) continue ;; esac
      note "backing up $target -> $target.pre-stow"
      run mv "$target" "$target.pre-stow"
    done < <(find "$DOTFILES/$pkg" \( -type f -o -type l \) -print0)
  done
}

step_stow() {
  log "Stowing dotfiles"
  run mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/bin"
  backup_conflicts
  # jdtls in the repo is an absolute symlink, which stow refuses; ignore it.
  run stow -d "$DOTFILES" -t "$HOME" --ignore='jdtls' --restow "${STOW_PKGS[@]}"
}

step_installers() {
  log "Installers"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if [ "$DRY" = 1 ]; then note "[dry-run] install oh-my-zsh"; else
      RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi
  else note "oh-my-zsh already installed"; fi

  run rustup default stable
  run mkdir -p "$HOME/.npm-global" "$HOME/.local/share/nvim" "$HOME/.local/bin"
  run npm config set prefix "$HOME/.npm-global"

  if [ ! -d "$HOME/.local/share/nvim/debugpy" ]; then
    run python3 -m venv "$HOME/.local/share/nvim/debugpy"
    run "$HOME/.local/share/nvim/debugpy/bin/pip" install -q debugpy
  fi
  if [ ! -d "$HOME/.local/share/nvim/js-debug" ]; then
    if [ "$DRY" = 1 ]; then note "[dry-run] js-debug"; else
      curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz | tar -xz -C "$HOME/.local/share/nvim"
    fi
  fi
  if [ ! -x "$HOME/.local/share/netcoredbg/netcoredbg" ]; then
    if [ "$DRY" = 1 ]; then note "[dry-run] netcoredbg"; else
      curl -fsSL https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz | tar -xz -C "$HOME/.local/share"
      ln -sf "$HOME/.local/share/netcoredbg/netcoredbg" "$HOME/.local/bin/netcoredbg"
    fi
  fi
  run go install github.com/AmaneKai/hopes@latest

  # hopes task data (private repo; needs `gh auth login` first, otherwise skipped)
  if [ ! -d "$HOME/hopes-data" ]; then
    if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
      run gh repo clone AmaneKai/hopes-data "$HOME/hopes-data"
    else
      note "gh not logged in; later run: gh auth login && gh repo clone AmaneKai/hopes-data ~/hopes-data"
    fi
  fi
  if [ ! -e "$HOME/.config/hopes/config.toml" ]; then
    put "$HOME/.config/hopes/config.toml" <<EOT
[sync]
enabled = true
debounce_seconds = 5
data_dir = "$HOME/hopes-data"
remote = "origin"
branch = "main"
pull_on_startup = true
EOT
  fi
}

step_system() {
  log "System settings (shell, services, locale, keymap)"
  run sudo chsh -s /usr/bin/zsh "$USER"
  run sudo systemctl enable --now NetworkManager bluetooth

  # Wifi power saving off: removes latency spikes on idle connections (costs a little battery)
  if [ "$DRY" = 1 ]; then note "[dry-run] write /etc/NetworkManager/conf.d/wifi-powersave.conf"; else
    printf '[connection]\nwifi.powersave = 2\n' | sudo tee /etc/NetworkManager/conf.d/wifi-powersave.conf >/dev/null
    sudo systemctl reload NetworkManager || true
  fi

  run sudo sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/; s/^#\(ja_JP.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  run sudo locale-gen
  local u=en_US.UTF-8
  run sudo localectl set-locale LANG=$u LC_ADDRESS=$u LC_IDENTIFICATION=$u LC_MEASUREMENT=$u LC_MONETARY=$u LC_NAME=$u LC_NUMERIC=$u LC_PAPER=$u LC_TELEPHONE=$u LC_TIME=$u

  run sudo localectl set-keymap jp106
  run sudo localectl set-x11-keymap jp jp106 "" terminate:ctrl_alt_bksp
}

step_kde() {
  log "KDE Plasma (Wayland): layout, fonts, theme, Japanese input, wallpaper"
  if ! command -v kwriteconfig6 >/dev/null; then note "kwriteconfig6 not found (Plasma not installed?); skipping"; return; fi

  # Keyboard layout
  kw --file kxkbrc --group Layout --key Use true
  kw --file kxkbrc --group Layout --key LayoutList jp
  kw --file kxkbrc --group Layout --key VariantList ""
  kw --file kxkbrc --group Layout --key Model jp106
  kw --file kxkbrc --group Layout --key ResetOldOptions true
  kw --file kxkbrc --group Layout --key Options terminate:ctrl_alt_bksp

  # Fonts
  local f10="$FONT,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1" f9="$FONT,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1" k
  for k in font fixed menuFont toolBarFont activeFont; do kw --file kdeglobals --group General --key "$k" "$f10"; done
  kw --file kdeglobals --group General --key smallestReadableFont "$f9"
  kw --file kdeglobals --group WM --key activeFont "$f10"
  for k in gtk-3.0 gtk-4.0; do
    kw --file "$HOME/.config/$k/settings.ini" --group Settings --key gtk-font-name "$FONT, 10"
  done

  # Colour scheme
  if [ "$DRY" = 0 ] && command -v plasma-apply-colorscheme >/dev/null && [ -n "${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]; then
    plasma-apply-colorscheme RosePine || true
  else
    kw --file kdeglobals --group General --key ColorScheme RosePine
  fi

  # Japanese input: KWin must launch fcitx5 (never start it by hand or from autostart)
  if ! grep -qs '^Name=mozc' "$HOME/.config/fcitx5/profile"; then
    put "$HOME/.config/fcitx5/profile" <<'EOF'
[Groups/0]
Name=Default
Default Layout=jp
DefaultIM=mozc

[Groups/0/Items/0]
Name=keyboard-jp
Layout=

[Groups/0/Items/1]
Name=mozc
Layout=

[GroupOrder]
0=Default
EOF
  else note "fcitx5 profile already has mozc; leaving it"; fi
  if ! grep -qs ShareInputState "$HOME/.config/fcitx5/config"; then
    put "$HOME/.config/fcitx5/config" <<'EOF'
[Hotkey/TriggerKeys]
0=Zenkaku_Hankaku
1=Control+space

[Behavior]
# Share input state across all windows and programs
ShareInputState=All
EOF
  fi
  kw --file kwinrc --group Wayland --key InputMethod /usr/share/applications/org.fcitx.Fcitx5.desktop
  put "$HOME/.config/autostart/org.fcitx.Fcitx5.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Fcitx 5
Hidden=true
EOF

  # Wallpaper: desktop, lock screen, login screen
  local src="$DOTFILES/assets/wallpapers/$WALLPAPER_NAME" dst="$HOME/Pictures/Wallpapers/$WALLPAPER_NAME"
  if [ ! -f "$src" ]; then note "$src missing; skipping wallpaper"; return; fi
  run mkdir -p "$HOME/Pictures/Wallpapers"
  run cp -n "$src" "$dst"
  if [ "$DRY" = 0 ] && command -v plasma-apply-wallpaperimage >/dev/null && [ -n "${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]; then
    plasma-apply-wallpaperimage "$dst" || true
  else
    note "no Plasma session; set the desktop wallpaper after first login"
  fi
  kw --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$dst"
  kw --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key PreviewImage "file://$dst"
  # Plasma Login Manager cannot read $HOME, so give it a shared copy
  if pacman -Q plasma-login-manager >/dev/null 2>&1; then
    run sudo mkdir -p /usr/share/wallpapers/anime_skull
    run sudo install -m644 "$src" "/usr/share/wallpapers/anime_skull/$WALLPAPER_NAME"
    run sudo kwriteconfig6 --file /etc/plasmalogin.conf --group Greeter --key WallpaperPluginId org.kde.image
    run sudo kwriteconfig6 --file /etc/plasmalogin.conf --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///usr/share/wallpapers/anime_skull/$WALLPAPER_NAME"
  elif pacman -Q sddm >/dev/null 2>&1; then
    note "SDDM detected: set the login wallpaper in System Settings > Login Screen"
  fi
}

check_distro
for s in packages aur stow installers system kde; do
  if want "$s"; then "step_$s"; else note "skipping $s"; fi
done

cat <<'EOF'

==> Done. Remaining by hand:
  - Log out and back in (zsh login shell, keyboard layout, fcitx5 via KWin, fonts, locale).
    A live Plasma session rewrites kxkbrc and the fcitx5 profile on logout, so run this
    script from a TTY or before your first Plasma login on a fresh install.
  - SSH keys, git credentials, browser and app logins are NOT restored.
  - jdtls (Java LSP) is not installed; the repo's scripts/jdtls link was ignored.
EOF
