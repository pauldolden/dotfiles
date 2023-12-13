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
config.enable_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 50
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

config.window_frame = {
	font_size = 16.0,
}

config.font = wezterm.font("VictorMono Nerd Font Mono", { weight = "Bold" })

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end

	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab)
	local title = tab_title(tab)

	if tab then
		return {
			{ Text = "  " .. title .. "  " },
		}
	end
	return title
end)

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
