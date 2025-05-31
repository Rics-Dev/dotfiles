-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
-- Performance monitoring
if os.getenv("SKETCHYBAR_DEBUG") then
  require("helpers.performance")
end

-- Cleanup timer
sbar.add("item", {
  drawing = false,
  updates = true,
}):subscribe("routine", function()
  if math.random() < 0.1 then -- 10% chance per routine
    require("helpers.cache").cleanup()
    collectgarbage("collect")
  end
end)

-- Add event handler for reloading spaces (triggered by srhd)
sbar.add("item", {
    drawing = false,
    updates = true,
}):subscribe("reload_spaces", function(env)
    -- Option 1: Just reload the entire SketchyBar (cleanest approach)
    sbar.exec("sketchybar --reload")
end)
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
