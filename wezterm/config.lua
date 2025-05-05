local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Define your custom Ghostty color scheme
config.color_schemes = {
	["GhosttyTheme"] = {
		-- The default text color
		foreground = "#abb2bf",
		-- The default background color
		background = "#0F1219",

		-- Cursor colors
		cursor_bg = "#5ab0f6",
		cursor_fg = "#0F1219",

		-- Selection colors
		selection_bg = "#2c313a",
		selection_fg = "#abb2bf",

		-- ANSI colors
		ansi = {
			"#3f4451", -- Black (0)
			"#ef5f6b", -- Red (1)
			"#98c379", -- Green (2)
			"#e5c07b", -- Yellow (3)
			"#5ab0f6", -- Blue (4)
			"#c678dd", -- Purple (5)
			"#56b6c2", -- Cyan (6)
			"#d7dae0", -- White (7)
		},
		brights = {
			"#4f5666", -- Bright Black (8)
			"#ff616e", -- Bright Red (9)
			"#a5e075", -- Bright Green (10)
			"#ebc275", -- Bright Yellow (11)
			"#61afef", -- Bright Blue (12)
			"#de73ff", -- Bright Purple (13)
			"#4dbdcb", -- Bright Cyan (14)
			"#e6e6e6", -- Bright White (15)
		},
	},
}

-- Use the custom color scheme

config = {
	--enable_wayland = true,
	animation_fps = 240,
	max_fps = 240,
	color_scheme = "GhosttyTheme",
	--color_scheme = "OneDark (base16)",
	default_cursor_style = "BlinkingBlock",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	window_decorations = "RESIZE",
	check_for_updates = false,
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = false,
	font_size = 15,
	font = wezterm.font("JetBrains Mono NL"),
	-- font = wezterm.font({
	-- 	family = "JetBrainsMono Nerd Font",
	-- 	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	-- }),
	-- enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_padding = {
		left = 14,
		right = 14,
		top = 14,
		bottom = 0,
	},
	window_background_opacity = 0.95,
	keys = {
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = act.SpawnTab("DefaultDomain"),
		},
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = act.ActivateTabRelative(-1),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = act.ActivateTabRelative(1),
		},
		{
			key = "w",
			mods = "CTRL|SHIFT",
			action = act.CloseCurrentTab({ confirm = true }),
		},
	},
	-- -- tmux
	-- leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 },
	-- config.keys = {
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "c",
	-- 		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "x",
	-- 		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "b",
	-- 		action = wezterm.action.ActivateTabRelative(-1),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "n",
	-- 		action = wezterm.action.ActivateTabRelative(1),
	-- 	},
	-- 	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	-- 	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "'",
	-- 		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = ";",
	-- 		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "h",
	-- 		action = wezterm.action.ActivatePaneDirection("Left"),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "j",
	-- 		action = wezterm.action.ActivatePaneDirection("Down"),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "k",
	-- 		action = wezterm.action.ActivatePaneDirection("Up"),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "l",
	-- 		action = wezterm.action.ActivatePaneDirection("Right"),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "LeftArrow",
	-- 		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "RightArrow",
	-- 		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "DownArrow",
	-- 		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	-- 	},
	-- 	{
	-- 		mods = "LEADER",
	-- 		key = "UpArrow",
	-- 		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	-- 	},
	-- }

	-- for i = 0, 9 do
	-- 	-- leader + number to activate that tab
	-- 	table.insert(config.keys, {
	-- 		key = tostring(i),
	-- 		mods = "LEADER",
	-- 		action = wezterm.action.ActivateTab(i),
	-- 	})
	-- end
}
return config
