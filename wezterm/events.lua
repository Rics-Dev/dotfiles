local wezterm = require("wezterm")
local mux = wezterm.mux

-- Maximize the window on startup
wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)
