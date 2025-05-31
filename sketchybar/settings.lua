return {
	paddings = 3,
	group_paddings = 5,

	icons = "sf-symbols",

	font = require("helpers.default_font"),
	performance = {
		cache_ttl = 5,
		update_throttle = 50,
		cleanup_interval = 300,
		enable_debug = os.getenv("SKETCHYBAR_DEBUG") == "1",
		disable_animations_in_fullscreen = true,
		disable_shadows_in_fullscreen = true,
		reduce_update_frequency_in_fullscreen = true,
		fast_fullscreen_transitions = true,
	},
	-- Fullscreen-specific optimizations
	fullscreen = {
		hide_delay = 0, -- Immediate hiding
		show_delay = 0, -- Immediate showing
		animation_duration = 0, -- No animations during transitions
		disable_blur = true,
		disable_shadows = true,
	},
}
