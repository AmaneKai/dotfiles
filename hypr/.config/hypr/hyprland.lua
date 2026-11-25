-- Hyprland 0.57 Lua config: the "library" rice (Yorushika / Fireworks Beneath My Shoes).
-- Each concern lives in its own module under conf/, loaded in dependency order. A
-- module only reaches another through conf.palette; everything else is independent.

require("conf.env")        -- environment: one system theme, Wayland everywhere
require("conf.monitors")   -- scale, modes, docking
require("conf.look")       -- square windows, borders, blur, animations
require("conf.input")      -- trackpad, mice, gestures
require("conf.binds")      -- keybindings
require("conf.rules")      -- window and layer rules
require("conf.autostart")  -- the long-running desktop pieces
