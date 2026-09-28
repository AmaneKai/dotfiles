local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'rose-pine'
config.colors = {
  foreground = '#ffffff',
  background = '#121212',
}

config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'Noto Sans CJK JP',
  'Noto Color Emoji',
}
config.font_size = 12.0

config.window_background_opacity = 0.95
config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.default_cursor_style = 'SteadyBlock'
config.hide_tab_bar_if_only_one_tab = true
config.use_ime = true
config.audible_bell = 'Disabled'

return config
