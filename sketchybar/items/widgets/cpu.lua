local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.cpu },
  label = {
    string = "cpu ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6
})

local cpu_history = {}
local max_history = 60

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  -- Store history for trend analysis
  table.insert(cpu_history, load)
  if #cpu_history > max_history then
    table.remove(cpu_history, 1)
  end
  cpu:push({ load / 100. })

  -- Dynamic color based on load and trend
  local color = colors.blue
  local trend = #cpu_history > 1 and (cpu_history[#cpu_history] - cpu_history[#cpu_history - 1]) or 0
  if load > 80 then
    color = trend > 5 and colors.red or colors.orange
  elseif load > 60 then
    color = colors.orange
  elseif load > 30 then
    color = colors.yellow
  end

  cpu:set({
    graph = { color = color },
    label = {
      string = "cpu " .. env.total_load .. "%",
      color = load > 70 and colors.white or colors.grey
    },
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = { color = colors.bg1 }
})

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings
})
