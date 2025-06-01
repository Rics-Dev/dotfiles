local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Toggle button for showing/hiding right side widgets
local toggle_button = sbar.add("item", "widgets.toggle", {
  position = "right",
  icon = {
    string = "􀆇", -- SF Symbol for eye (visible)
    font = {
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.white,
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
    corner_radius = 9,
    height = 28,
  },
  padding_left = 1,
  padding_right = 1,
})

-- Double border bracket for toggle button
sbar.add("bracket", "widgets.toggle.bracket", { toggle_button.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
    corner_radius = 11,
    border_width = 1,
  }
})

-- State tracking
local widgets_visible = true
local widget_names = {
  "widgets.battery",
  "widgets.battery.bracket",
  "widgets.battery.padding",
  "widgets.volume1",
  "widgets.volume2", 
  "widgets.volume.bracket",
  "widgets.volume.padding",
  "widgets.wifi1",
  "widgets.wifi2",
  "widgets.wifi.padding",
  "widgets.wifi.bracket",
  "widgets.cpu",
  "widgets.cpu.bracket", 
  "widgets.cpu.padding",
  "widgets.bluetooth",
  "widgets.bluetooth.bracket",
  "widgets.bluetooth.padding",
}

-- Function to toggle widgets visibility
local function toggle_widgets()
  widgets_visible = not widgets_visible
  
  -- Animate the toggle button
  sbar.animate("tanh", 8, function()
    toggle_button:set({
      icon = {
        string = widgets_visible and "􀆇" or "􀆈", -- eye / eye.slash
        color = widgets_visible and colors.white or colors.grey,
      },
      background = {
        color = widgets_visible and colors.bg2 or colors.with_alpha(colors.bg2, 0.5),
        border_color = widgets_visible and colors.black or colors.with_alpha(colors.black, 0.5),
      }
    })
  end)
  
  -- Toggle widget visibility
  for _, widget_name in ipairs(widget_names) do
    sbar.set(widget_name, { drawing = widgets_visible })
  end
  
  -- Also hide any open popups when hiding widgets
  if not widgets_visible then
    sbar.set("widgets.battery", { popup = { drawing = false } })
    sbar.set("widgets.volume.bracket", { popup = { drawing = false } })
    sbar.set("widgets.wifi.bracket", { popup = { drawing = false } })
    sbar.set("widgets.bluetooth", { popup = { drawing = false } })
  end
end

-- Function to handle hover effects
local function handle_hover_enter()
  if widgets_visible then
    sbar.animate("tanh", 6, function()
      toggle_button:set({
        background = {
          border_color = colors.with_alpha(colors.white, 0.35),
          color = colors.with_alpha(colors.white, 0.06),
        }
      })
    end)
  end
end

local function handle_hover_exit()
  if widgets_visible then
    sbar.animate("tanh", 6, function()
      toggle_button:set({
        background = {
          border_color = colors.black,
          color = colors.bg2,
        }
      })
    end)
  end
end

-- Subscribe to mouse events
toggle_button:subscribe("mouse.clicked", toggle_widgets)
toggle_button:subscribe("mouse.entered", handle_hover_enter)
toggle_button:subscribe("mouse.exited", handle_hover_exit)

-- Add spacing after toggle button
sbar.add("item", "widgets.toggle.spacing", {
  position = "right",
  width = 10
})
