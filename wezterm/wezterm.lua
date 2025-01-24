package.path = os.getenv("HOME") .. "/.dotfiles/wezterm/?.lua;" .. package.path

local config = require("config")
require("events")

return config
