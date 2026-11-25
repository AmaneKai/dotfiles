local STARTUP_COMMANDS = {
    "hyprpaper",
    "sh -c 'qs -c library || mako'",
    "/usr/lib/hyprpolkitagent/hyprpolkitagent",
    "hypridle",
    os.getenv("HOME") .. "/.config/hypr/scripts/page-sounds.sh",
    "udiskie",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_MENU_PREFIX QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_QPA_PLATFORM QS_ICON_THEME XCURSOR_THEME XCURSOR_SIZE",
}

hl.on("hyprland.start", function()
    for _, command in ipairs(STARTUP_COMMANDS) do
        hl.exec_cmd(command)
    end
end)
