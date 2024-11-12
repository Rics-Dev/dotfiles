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

-- This is where you actually apply your config choices
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0
config.default_cursor_style = "BlinkingBar"
config.window_background_opacity = 0.95

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true

-- tmux
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
--config.leader = { key = "F13", mods = "", timeout_milliseconds = 2000 }
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

config.color_scheme = "GruvboxDark"

-- config.colors = {
-- 	-- -- The default text color
-- 	-- foreground = "#abb2bf",
-- 	-- -- The default background color
-- 	-- background = "#272C33",
-- 	-- -- Cursor colors
-- 	-- cursor_bg = "#8fee96",
-- 	-- cursor_fg = "#272C33",
-- 	-- cursor_border = "#8fee96",
-- 	-- -- Selection colors
-- 	-- selection_fg = "#ffffff",
-- 	-- selection_bg = "#3e4452",
-- 	-- -- The color of the scrollbar "thumb"
-- 	-- scrollbar_thumb = "#3e4452",
-- 	-- -- The color of the split lines between panes
-- 	-- split = "#3e4452",
-- 	-- -- ANSI colors
-- 	-- ansi = {
-- 	-- 	"#1e2127", -- black
-- 	-- 	"#e06c75", -- red
-- 	-- 	"#98c379", -- green
-- 	-- 	"#d19a66", -- yellow
-- 	-- 	"#61afef", -- blue
-- 	-- 	"#c678dd", -- magenta
-- 	-- 	"#56b6c2", -- cyan
-- 	-- 	"#828791", -- white
-- 	-- },
-- 	-- -- Bright ANSI colors
-- 	-- brights = {
-- 	-- 	"#5c6370", -- bright black
-- 	-- 	"#e06c75", -- bright red
-- 	-- 	"#98c379", -- bright green
-- 	-- 	"#d19a66", -- bright yellow
-- 	-- 	"#61afef", -- bright blue
-- 	-- 	"#c678dd", -- bright magenta
-- 	-- 	"#56b6c2", -- bright cyan
-- 	-- 	"#e6efff", -- bright white
-- 	-- },
-- 	-- -- Tab bar colors
-- 	-- tab_bar = {
-- 	-- 	background = "#3e4452",
-- 	-- 	active_tab = {
-- 	-- 		bg_color = "#e6efff",
-- 	-- 		fg_color = "#000000",
-- 	-- 	},
-- 	-- 	inactive_tab = {
-- 	-- 		bg_color = "#3e4452",
-- 	-- 		fg_color = "#abb2bf",
-- 	-- 	},
-- 	-- 	inactive_tab_edge = "#575757",
-- 	foreground = "#ebdbb2",
-- 	background = "#282828",
--
-- 	cursor_bg = "#ebdbb2",
-- 	cursor_border = "#ebdbb2",
-- 	cursor_fg = "#282828",
--
-- 	selection_bg = "#3c3836",
-- 	selection_fg = "#ebdbb2",
--
-- 	ansi = {
-- 		"#282828", -- black
-- 		"#cc241d", -- red
-- 		"#98971a", -- green
-- 		"#d79921", -- yellow
-- 		"#458588", -- blue
-- 		"#b16286", -- purple
-- 		"#689d6a", -- aqua
-- 		"#a89984", -- gray
-- 	},
-- 	brights = {
-- 		"#928374", -- bright black
-- 		"#fb4934", -- bright red
-- 		"#b8bb26", -- bright green
-- 		"#fabd2f", -- bright yellow
-- 		"#83a598", -- bright blue
-- 		"#d3869b", -- bright purple
-- 		"#8ec07c", -- bright aqua
-- 		"#ebdbb2", -- bright white
-- 	},
--
-- 	-- Extra Gruvbox colors for customization
-- 	tab_bar = {
-- 		background = "#282828",
-- 		active_tab = { bg_color = "#3c3836", fg_color = "#ebdbb2" },
-- 		inactive_tab = { bg_color = "#282828", fg_color = "#928374" },
-- 	},
-- }

-- Return the configuration
return config
