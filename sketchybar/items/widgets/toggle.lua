local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Toggle button for showing/hiding right side widgets
local toggle_button = sbar.add("item", "widgets.toggle", {
  position = "right",
  icon = {
    string = icons.toggle.visible,
    font = {
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.white,
    padding_left = 9,
    padding_right = 12,
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
  },
})

-- State tracking
local widgets_visible = true

local widget_items_cache = nil
local cache_timestamp = 0
local cache_ttl = 10 -- Cache for 10 seconds

local function get_widget_items()
  local current_time = os.time()

  if widget_items_cache and (current_time - cache_timestamp) < cache_ttl then
    return widget_items_cache
  end

  local widget_items = {}

  local success, sketchybar_result = pcall(function()
    local handle = io.popen("sketchybar --query bar 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return result
    end
    return ""
  end)

  if success and sketchybar_result and sketchybar_result ~= "" then
    for item in sketchybar_result:gmatch('"([^"]*widgets%.[^"]*)"') do
      if not item:match("toggle") then -- Exclude toggle items
        table.insert(widget_items, item)
      end
    end
  end

  local seen = {}
  local unique_items = {}
  for _, item in ipairs(widget_items) do
    if not seen[item] then
      seen[item] = true
      local success_verify, query_result = pcall(function()
        return sbar.query(item)
      end)
      if success_verify and query_result then
        table.insert(unique_items, item)
      end
    end
  end

  table.sort(unique_items)

  widget_items_cache = unique_items
  cache_timestamp = current_time

  return unique_items
end

local function toggle_widgets()
  widgets_visible = not widgets_visible
  sbar.animate("tanh", 8, function()
    toggle_button:set({
      icon = {
        string = widgets_visible and icons.toggle.visible or icons.toggle.hidden,
        color = widgets_visible and colors.white or colors.grey,
      },
      background = {
        color = widgets_visible and colors.bg2 or colors.with_alpha(colors.bg2, 0.5),
        border_color = widgets_visible and colors.black or colors.with_alpha(colors.black, 0.5),
      }
    })
  end)
  
  local widget_patterns = {
    "/^widgets\\.battery/",
    "/^widgets\\.volume/", 
    "/^widgets\\.wifi/",
    "/^widgets\\.cpu/",
    "/^widgets\\.bluetooth/"
  }
  
  -- Bulk toggle using regex patterns (much faster than individual calls)
  for _, pattern in ipairs(widget_patterns) do
    pcall(function()
      sbar.set(pattern, { drawing = widgets_visible })
    end)
  end
  
  -- Close any open popups when hiding widgets
  if not widgets_visible then
    local popup_widgets = {
      "widgets.battery",
      "widgets.volume.bracket", 
      "widgets.wifi.bracket",
      "widgets.bluetooth"
    }
    
    for _, widget in ipairs(popup_widgets) do
      pcall(function()
        sbar.set(widget, { popup = { drawing = false } })
      end)
    end
  end
  
  -- Clear cache on toggle to refresh widget list next time
  widget_items_cache = nil
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
  width = 5
})

-- Export functions for external use if needed
return {
  toggle_widgets = toggle_widgets,
  get_widget_items = get_widget_items,
  is_visible = function() return widgets_visible end
}
