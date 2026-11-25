local palette = require("conf.palette")

local BLUR = {
    enabled    = true,
    size       = 9,
    passes     = 4,
    noise      = 0.04,
    contrast   = 0.9,
    brightness = 0.8,
    vibrancy   = 0.2,
    popups     = true,
}

hl.config({
    general = {
        gaps_in          = 6,
        gaps_out         = 18,
        border_size      = 1,
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
        col = {
            active_border   = palette.rgba("accent"),
            inactive_border = palette.rgba("surface"),
        },
    },
    decoration = {
        rounding         = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow           = { enabled = false },
        blur             = BLUR,
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        allow_session_lock_restore = true,
    },
    render = { cm_auto_hdr = 0 },
})

hl.curve("quick",  { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("glitch", { type = "bezier", points = { { 0.9, -0.3 }, { 0.1, 1.3 } } })

hl.animation({ leaf = "global",     enabled = true, speed = 6,   bezier = "quick" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4,   bezier = "quick",  style = "popin 95%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.6, bezier = "glitch", style = "slidefade 6%" })
hl.animation({ leaf = "layers",     enabled = true, speed = 4,   bezier = "quick",  style = "fade" })
