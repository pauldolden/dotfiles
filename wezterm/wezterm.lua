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
config.use_fancy_tab_bar = false
config.tab_max_width = 50

config.window_frame = {
	font_size = 16.0,
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab then
		return {
			{ Text = "  " .. title .. "  " },
		}
	end
	return title
end)

config.colors = {
	foreground = "#c8d3f5",
	background = "#222436",
	cursor_bg = "#c8d3f5",
	cursor_border = "#c8d3f5",
	cursor_fg = "#222436",
	selection_bg = "#2d3f76",
	selection_fg = "#c8d3f5",
	ansi = { "#1b1d2b", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#828bb8" },
	brights = { "#444a73", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#c8d3f5" },
	tab_bar = {
		inactive_tab_edge = "#1e2030",
		background = "#191b28",
		active_tab = {
			fg_color = "#82aaff",
			bg_color = "#222436",
		},
		inactive_tab = {
			bg_color = "#1e2030",
			fg_color = "#545c7e",
		},
		inactive_tab_hover = {
			bg_color = "#1e2030",
			fg_color = "#82aaff",
		},
		new_tab_hover = {
			fg_color = "#1e2030",
			bg_color = "#82aaff",
		},
		new_tab = {
			fg_color = "#82aaff",
			bg_color = "#191b28",
		},
	},
}

config.keys = {
	{
		key = "DownArrow",
		mods = "OPT",
		action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 25 } }),
	},
	{
		key = "UpArrow",
		mods = "OPT",
		action = wezterm.action.SplitPane({ direction = "Up", size = { Percent = 25 } }),
	},
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SplitPane({ direction = "Left", size = { Percent = 50 } }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 } }),
	},
}

-- and finally, return the configuration to wezterm
return config
