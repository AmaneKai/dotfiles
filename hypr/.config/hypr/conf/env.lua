local ENVIRONMENT = {
    XCURSOR_SIZE                 = "24",
    HYPRCURSOR_SIZE              = "24",
    XCURSOR_THEME                = "Library",
    HYPRCURSOR_THEME             = "Library",
    QT_QPA_PLATFORMTHEME         = "kde",
    QT_STYLE_OVERRIDE            = "kvantum",
    QT_QPA_PLATFORM              = "wayland;xcb",
    QT_AUTO_SCREEN_SCALE_FACTOR  = "1",
    XDG_MENU_PREFIX              = "plasma-",
    ELECTRON_OZONE_PLATFORM_HINT = "auto",
    MOZ_ENABLE_WAYLAND           = "1",
    QS_ICON_THEME                = "breeze-dark",
}

for name, value in pairs(ENVIRONMENT) do
    hl.env(name, value)
end

hl.config({ xwayland = { force_zero_scaling = true } })
