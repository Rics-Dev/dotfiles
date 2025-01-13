-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

local mux = wezterm.mux

-- This will hold the configuration.
if wezterm.config_builder then
	config = wezterm.config_builder()
end

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Fonts and appearance
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.0
config.default_cursor_style = "BlinkingBar"
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true
config.enable_wayland = false

-- Scrolling
config.scrollback_lines = 2000
config.adjust_window_size_when_changing_font_size = false

config.audible_bell = "Disabled"

config.colors = {
	foreground = "#abb2bf",
	background = "#272C33",
	cursor_bg = "#8fee96",
	cursor_fg = "#272C33",
	cursor_border = "#8fee96",
	selection_bg = "#3e4452",
	selection_fg = "#ffffff",
	ansi = {
		"#1e2127",
		"#e06c75",
		"#98c379",
		"#d19a66",
		"#61afef",
		"#c678dd",
		"#56b6c2",
		"#828791",
	},
	brights = {
		"#5c6370",
		"#e06c75",
		"#98c379",
		"#d19a66",
		"#61afef",
		"#c678dd",
		"#56b6c2",
		"#e6efff",
	},
	tab_bar = {
		background = "#3e4452",
		active_tab = { bg_color = "#e6efff", fg_color = "#000000" },
		inactive_tab = { bg_color = "#3e4452", fg_color = "#abb2bf" },
	},
}

-- tmux
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{
		mods = "LEADER",
		key = "'",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = ";",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
}

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""
	if window:leader_is_active() then
		prefix = " " .. utf8.char(0xf303) -- Arch Linux icon (requires a Nerd Font)
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end
	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane
	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

config.window_frame = {
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
	font_size = 12.0,
	active_titlebar_bg = "#272C33",
	inactive_titlebar_bg = "#272C33",
}

return config
