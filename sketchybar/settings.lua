return {
	paddings = 3,
	group_paddings = 5,

	icons = "sf-symbols",

	font = require("helpers.default_font"),
	performance = {
		cache_ttl = 5,
		update_throttle = 100, -- ms
		cleanup_interval = 300, -- 5 minutes
		enable_debug = os.getenv("SKETCHYBAR_DEBUG") == "1",
	},
}
