package.path = os.getenv("HOME") .. "/.dotfiles/wezterm/?.lua;" .. package.path

local config = require("config")
require("events")
config.color_scheme = "OneDark (base16)"

return config
