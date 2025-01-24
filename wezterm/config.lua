local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	color_scheme = "OneDark (base16)",
	default_cursor_style = "BlinkingBlock",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	window_decorations = "RESIZE",
	check_for_updates = false,
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = false,
	font_size = 14,
	font = wezterm.font("JetBrains Mono NL"),
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
