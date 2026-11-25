local LAPTOP_OUTPUT       = "eDP-1"
local ACER_OUTPUT         = "desc:Acer Technologies VG270 P 0x01120DA7"
local LAPTOP_SCALE        = 1.25
local ACER_SCALE          = 1
local OTHER_MONITOR_SCALE = 1.25
local LAPTOP_MODE         = "2560x1440@120"

local BASE_DPI              = 96
local EVENT_SETTLE_MS       = 600
local SHELL_RESTART_MS      = 2200
local RESTART_SHELL_COMMAND = "$HOME/.config/hypr/scripts/restart-shell.sh"

local function is_placeholder_output(name)
    return name == "FALLBACK" or name:find("^HEADLESS") ~= nil
end

local function is_real_external(monitor)
    return monitor.name ~= LAPTOP_OUTPUT and not is_placeholder_output(monitor.name)
end

local function is_laptop_panel(monitor)
    return monitor.name == LAPTOP_OUTPUT
end

local function any_monitor(predicate)
    for _, monitor in ipairs(hl.get_monitors()) do
        if predicate(monitor) then return true end
    end
    return false
end

local function external_connected()
    return any_monitor(is_real_external)
end

local function laptop_panel_enabled()
    return any_monitor(is_laptop_panel)
end

local function laptop_panel_rule(disabled)
    return {
        output   = LAPTOP_OUTPUT,
        mode     = LAPTOP_MODE,
        position = "0x0",
        scale    = LAPTOP_SCALE,
        disabled = disabled,
    }
end

local function reconcile_laptop_panel()
    local external = external_connected()
    local enabled  = laptop_panel_enabled()

    if external and enabled then
        hl.monitor({ output = LAPTOP_OUTPUT, disabled = true })
        return
    end
    if not external and not enabled then
        hl.monitor(laptop_panel_rule(false))
    end
end

local function highest_scale()
    local highest = 1
    for _, monitor in ipairs(hl.get_monitors()) do
        highest = math.max(highest, monitor.scale)
    end
    return highest
end

local function apply_x11_dpi()
    local scale = highest_scale()
    if scale <= 1 then return end

    local dpi = math.floor(BASE_DPI * scale + 0.5)
    hl.exec_cmd(string.format("echo 'Xft.dpi: %d' | xrdb -merge", dpi))
end

local generation = 0

local function only_if_latest(captured_generation, action)
    return function()
        if captured_generation == generation then action() end
    end
end

local function restart_shell()
    hl.exec_cmd(RESTART_SHELL_COMMAND)
end

local function on_monitor_change()
    generation = generation + 1
    hl.timer(only_if_latest(generation, reconcile_laptop_panel), { timeout = EVENT_SETTLE_MS,  type = "oneshot" })
    hl.timer(only_if_latest(generation, restart_shell),          { timeout = SHELL_RESTART_MS, type = "oneshot" })
end

hl.monitor(laptop_panel_rule(external_connected()))
hl.monitor({ output = ACER_OUTPUT, mode = "preferred", position = "auto", scale = ACER_SCALE })
hl.monitor({ output = "",          mode = "preferred", position = "auto", scale = OTHER_MONITOR_SCALE })

hl.on("monitor.added",   on_monitor_change)
hl.on("monitor.removed", on_monitor_change)

hl.on("hyprland.start", function()
    hl.timer(reconcile_laptop_panel, { timeout = EVENT_SETTLE_MS, type = "oneshot" })
    apply_x11_dpi()
end)
