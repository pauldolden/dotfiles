-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font_size = 17.0
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.window_frame = {
	font_size = 16.0,
}

config.colors = {
	foreground = "#c0caf5",
	background = "#1a1b26",
	cursor_bg = "#c0caf5",
	cursor_border = "#c0caf5",
	cursor_fg = "#1a1b26",
	selection_bg = "#283457",
	selection_fg = "#c0caf5",
	ansi = {
		"#15161e",
		"#f7768e",
		"#9ece6a",
		"#e0af68",
		"#7aa2f7",
		"#bb9af7",
		"#7dcfff",
		"#a9b1d6",
	},
	brights = {
		"#414868",
		"#f7768e",
		"#9ece6a",
		"#e0af68",
		"#7aa2f7",
		"#bb9af7",
		"#7dcfff",
		"#c0caf5",
	},
	tab_bar = {
		inactive_tab_edge = "#16161e",
		background = "#191b28",
		active_tab = {
			fg_color = "#7aa2f7",
			bg_color = "#1a1b26",
		},
		inactive_tab = {
			bg_color = "#16161e",
			fg_color = "#545c7e",
		},
		inactive_tab_hover = {
			bg_color = "#16161e",
			fg_color = "#7aa2f7",
		},
		new_tab_hover = {
			fg_color = "#16161e",
			bg_color = "#7aa2f7",
		},
		new_tab = {
			fg_color = "#7aa2f7",
			bg_color = "#191b28",
		},
	},
}

-- and finally, return the configuration to wezterm
return config
