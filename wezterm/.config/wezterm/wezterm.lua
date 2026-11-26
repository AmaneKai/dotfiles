local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- COLORS
config.colors = {
  background = "black",
}
config.color_scheme = 'rose-pine'

-- APPEARANCE
config.enable_tab_bar = false
config.window_decorations = "NONE"
config.window_background_opacity = 0.90
config.macos_window_background_blur = 20
config.window_padding = {
  left = 10,
  right = 10,
  top = 40,
  bottom = 10,
}
config.default_cursor_style = 'SteadyBlock'
config.audible_bell = 'Disabled'
config.use_ime = true

-- FONT
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'Fira Code',
  'Noto Sans CJK JP',
  'Noto Color Emoji',
}
config.font_size = 16.0

-- KEYS
config.keys = {
  {
    key = ']',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ToggleAlwaysOnTop,
  },
}

return config
