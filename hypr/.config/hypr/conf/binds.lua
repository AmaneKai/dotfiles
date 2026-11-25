local MOD            = "SUPER"
local SCRIPTS        = "$HOME/.config/hypr/scripts/"
local LAUNCHER       = "sh -c 'qs -c library ipc call launcher toggle || fuzzel'"
local FIRST_WORKSPACE = 1
local LAST_WORKSPACE  = 10

local LOCK = "qs -c library ipc call lock lock || hyprlock"
local REGION_FALLBACK = [[region=$(slurp) && grim -g "$region" - | wl-copy --type image/png]]
local REGION_TO_CLIPBOARD = "qs -c library ipc call screenshot region || " .. REGION_FALLBACK
local CLIPBOARD_FALLBACK  = [[cliphist list | fuzzel --dmenu | cliphist decode | wl-copy]]
local CLIPBOARD_HISTORY   = "qs -c library ipc call bar toggle clipboard || " .. CLIPBOARD_FALLBACK
local ANNOTATE            = "qs -c library ipc call screenshot annotate"
local OVERVIEW            = "qs -c library ipc call overview toggle"

local function chord(...)
    return table.concat({ ... }, " + ")
end

local function run(command)
    return hl.dsp.exec_cmd(command)
end

local function script(name_and_arguments)
    return run(SCRIPTS .. name_and_arguments)
end

local function osd(action)
    return script("osd.sh " .. action)
end

local function cycle_windows(forward)
    return function()
        hl.dispatch(hl.dsp.window.cycle_next({ next = forward }))
        hl.dispatch(hl.dsp.window.bring_to_top())
    end
end

local function step_workspace(delta)
    return function()
        local workspace = hl.get_active_workspace()
        if not workspace then return end

        local target = workspace.id + delta
        local in_range = target >= FIRST_WORKSPACE and target <= LAST_WORKSPACE
        if in_range then hl.dispatch(hl.dsp.focus({ workspace = target })) end
    end
end

local function bind_launchers()
    hl.bind(chord(MOD, "Return"), run("ghostty"))
    hl.bind(chord(MOD, "D"),      run("fuzzel"))
    hl.bind(chord(MOD, "space"),  run(LAUNCHER))
end

local function bind_window_management()
    hl.bind(chord(MOD, "Q"),                hl.dsp.window.close())
    hl.bind(chord(MOD, "SHIFT", "space"),   hl.dsp.window.float({ action = "toggle" }))
    hl.bind(chord(MOD, "J"),                hl.dsp.layout("togglesplit"))
    hl.bind(chord(MOD, "SHIFT", "E"),       hl.dsp.exit())
    hl.bind(chord(MOD, "Tab"),              cycle_windows(true))
    hl.bind(chord(MOD, "SHIFT", "Tab"),     cycle_windows(false))
    hl.bind(chord(MOD, "mouse:272"),        hl.dsp.window.drag(),   { mouse = true })
    hl.bind(chord(MOD, "mouse:273"),        hl.dsp.window.resize(), { mouse = true })

    for _, direction in ipairs({ "left", "right", "up", "down" }) do
        hl.bind(chord(MOD, direction), hl.dsp.focus({ direction = direction }))
    end
end

local function bind_workspaces()
    for workspace = FIRST_WORKSPACE, LAST_WORKSPACE do
        local number_key = workspace % LAST_WORKSPACE
        hl.bind(chord(MOD, number_key),            hl.dsp.focus({ workspace = workspace }))
        hl.bind(chord(MOD, "SHIFT", number_key),   hl.dsp.window.move({ workspace = workspace }))
    end

    hl.bind(chord(MOD, "CTRL", "left"),  step_workspace(-1))
    hl.bind(chord(MOD, "CTRL", "right"), step_workspace(1))
    hl.bind(chord(MOD, "mouse_down"),    hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(chord(MOD, "mouse_up"),      hl.dsp.focus({ workspace = "e-1" }))
end

local function bind_session()
    hl.bind(chord(MOD, "L"),         run(LOCK))
    hl.bind(chord(MOD, "CTRL", "Q"), run(LOCK))
end

local function bind_capture()
    hl.bind(chord(MOD, "SHIFT", "S"), run(REGION_TO_CLIPBOARD))
    hl.bind(chord(MOD, "SHIFT", "W"), script("wallpaper.sh next"))
    hl.bind(chord(MOD, "SHIFT", "V"), run(CLIPBOARD_HISTORY))
    hl.bind(chord(MOD, "SHIFT", "A"), run(ANNOTATE))
    hl.bind(chord(MOD, "grave"),      run(OVERVIEW))
end

local function bind_volume_and_brightness()
    hl.bind("XF86AudioRaiseVolume",    osd("volume-up"),        { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume",    osd("volume-down"),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",           osd("volume-mute"),      { locked = true })
    hl.bind("XF86MonBrightnessUp",     osd("brightness-up"),    { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown",   osd("brightness-down"),  { locked = true, repeating = true })
    hl.bind(chord(MOD, "bracketright"), osd("volume-up"),       { repeating = true })
    hl.bind(chord(MOD, "bracketleft"),  osd("volume-down"),     { repeating = true })
end

local function bind_media()
    local PLAYERCTL_KEYS = {
        XF86AudioNext  = "next",
        XF86AudioPause = "play-pause",
        XF86AudioPlay  = "play-pause",
        XF86AudioPrev  = "previous",
    }
    for key, action in pairs(PLAYERCTL_KEYS) do
        hl.bind(key, run("playerctl " .. action), { locked = true })
    end
end

bind_launchers()
bind_window_management()
bind_workspaces()
bind_session()
bind_capture()
bind_volume_and_brightness()
bind_media()
