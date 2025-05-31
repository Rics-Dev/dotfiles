local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local cache = require("helpers.cache")
local throttle = require("helpers.throttle")

-- Enhanced configuration
local config = {
  animation_duration = 8, -- Slightly increased for smoother feel
  hover_animation_duration = 8, -- Faster hover responses
  max_app_icons = 6, -- Limit app icons per space for cleaner look
  icon_spacing = " ", -- Space between app icons
  update_throttle = 0.1, -- Throttle updates to prevent spam
  cache_ttl = 2, -- Cache workspace data for 2 seconds
  workspace_padding = 3,
  modern_styling = true, -- Enable enhanced visual effects
}

local spaces = {}
local current_focused_workspace = nil

local function create_space(workspace_id)
  if spaces[workspace_id] then
    return spaces[workspace_id]
  end

  local space = sbar.add("space", "space." .. workspace_id, {
    space = workspace_id,
    position = "left", -- Explicitly set position to left
    icon = {
      font = { 
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"]
      },
      string = tostring(workspace_id),
      padding_left = 14,
      padding_right = 10,
      color = colors.white,
      highlight_color = colors.accent.primary,
    },
    label = {
      padding_right = 16,
      padding_left = 6,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:15.0",
      y_offset = -1,
      max_chars = 35, -- Prevent overflow
    },
    padding_right = config.workspace_padding,
    padding_left = config.workspace_padding,
    background = {
      color = colors.bg1,
      border_width = 1.5,
      height = 28,
      border_color = colors.with_alpha(colors.grey, 0.25),
      corner_radius = 9,
      shadow = {
        drawing = false,
        color = colors.with_alpha(colors.black, 0.3),
        distance = 2,
        angle = 270
      }
    },
  })

  spaces[workspace_id] = space

  -- Enhanced bracket with glassmorphism effect
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.with_alpha(colors.white, 0.08),
      height = 32,
      border_width = 1,
      corner_radius = 11,
      shadow = {
        drawing = config.modern_styling,
        color = colors.with_alpha(colors.black, 0.2),
        distance = 3,
        angle = 270
      }
    }
  })

  space.bracket = space_bracket

  -- Enhanced space padding with dynamic sizing
  sbar.add("space", "space.padding." .. workspace_id, {
    space = workspace_id,
    position = "left", -- Explicitly set position to left
    script = "",
    width = 6,
  })

  -- Enhanced click handling with improved visual feedback
  space:subscribe("mouse.clicked", function(env)
    if workspace_id ~= current_focused_workspace then
      -- Immediate visual feedback
      sbar.animate("tanh", 8, function()
        space:set({
          background = { 
            color = colors.with_alpha(colors.accent.primary, 0.15),
            border_color = colors.with_alpha(colors.accent.primary, 0.6),
            shadow = { drawing = true }
          }
        })
      end)
      
      -- Execute workspace switch
      sbar.exec("aerospace workspace " .. workspace_id)
      
      -- Reset visual state after switch
      sbar.delay(80, function()
        sbar.animate("tanh", 12, function()
          space:set({
            background = { 
              color = colors.with_alpha(colors.white, 0.1),
              border_color = colors.with_alpha(colors.white, 0.5),
              shadow = { drawing = config.modern_styling }
            }
          })
        end)
      end)
    end
  end)

  -- Enhanced hover effects with better visual hierarchy
  space:subscribe("mouse.entered", function(_)
    if workspace_id ~= current_focused_workspace then
      sbar.animate("tanh", config.hover_animation_duration, function()
        space:set({
          background = { 
            border_color = colors.with_alpha(colors.white, 0.35),
            color = colors.with_alpha(colors.white, 0.06),
            shadow = { drawing = true }
          }
        })
      end)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    if workspace_id ~= current_focused_workspace then
      sbar.animate("tanh", config.hover_animation_duration, function()
        space:set({
          background = { 
            border_color = colors.with_alpha(colors.grey, 0.25),
            color = colors.bg1,
            shadow = { drawing = false }
          }
        })
      end)
    end
  end)

  return space
end

-- Optimized cleanup with batch operations
local function cleanup_removed_workspaces(active_workspace_ids)
  local active_set = {}
  local to_remove = {}
  
  for _, id in ipairs(active_workspace_ids) do
    active_set[id] = true
  end
  
  for workspace_id, space in pairs(spaces) do
    if not active_set[workspace_id] then
      table.insert(to_remove, workspace_id)
    end
  end
  
  -- Batch remove operations for better performance
  if #to_remove > 0 then
    for _, workspace_id in ipairs(to_remove) do
      local space = spaces[workspace_id]
      if space and space.bracket then
        sbar.remove(space.bracket.name)
      end
      sbar.remove("space.padding." .. workspace_id)
      sbar.remove("space." .. workspace_id)
      spaces[workspace_id] = nil
    end
    
    -- Clear related cache entries
    cache.clear("workspace_apps_")
  end
end

-- Enhanced app icon processing with smart truncation
local function update_workspace_apps(workspace_id)
  local cache_key = "workspace_apps_" .. workspace_id
  local cached_apps = cache.get(cache_key, config.cache_ttl)
  
  if cached_apps then
    local space = spaces[workspace_id]
    if space then
      space:set({ label = { string = cached_apps } })
    end
    return
  end

  sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'", function(windows_output)
    local icon_line = ""

    if windows_output and windows_output ~= "" then
      local seen_apps = {}
      local app_list = {}
      local icon_count = 0

      -- Parse and deduplicate app names with limit
      for app_name in windows_output:gmatch("[^\r\n]+") do
        app_name = app_name:match("^%s*(.-)%s*$") -- trim whitespace
        if app_name and app_name ~= "" and not seen_apps[app_name] and icon_count < config.max_app_icons then
          seen_apps[app_name] = true
          table.insert(app_list, app_name)
          icon_count = icon_count + 1
        end
      end

      -- Build optimized icon string
      for i, app_name in ipairs(app_list) do
        local icon = app_icons[app_name] or app_icons["Default"] or "●"
        icon_line = icon_line .. icon
        if i < #app_list then
          icon_line = icon_line .. config.icon_spacing
        end
      end
      
      -- Add overflow indicator if we hit the limit
      if icon_count == config.max_app_icons and #app_list < icon_count then
        icon_line = icon_line .. " ..."
      end
    end
    
    -- Cache the result
    cache.set(cache_key, icon_line)
    
    local space = spaces[workspace_id]
    if space then
      space:set({ label = { string = icon_line } })
    end
  end)
end


-- Simplified update function matching original logic more closely
local function update_workspaces()
  throttle("update_workspaces", config.update_throttle, function()
    -- Get both focused and non-empty workspaces in separate calls (like original)
    sbar.exec("aerospace list-workspaces --monitor focused --format '%{workspace}:%{workspace-is-focused}'", function(all_workspaces_output)
      local focused_workspace = nil
      local all_workspace_data = {}

      -- Parse all workspace data
      if all_workspaces_output and all_workspaces_output ~= "" then
        for line in all_workspaces_output:gmatch("[^\r\n]+") do
          local workspace_str, is_focused_str = line:match("^%s*(.-):(.*)")
          if workspace_str and is_focused_str then
            local workspace_id = tonumber(workspace_str)
            local is_focused = is_focused_str:match("true") ~= nil

            if workspace_id and workspace_id > 0 then
              table.insert(all_workspace_data, {id = workspace_id, focused = is_focused})
              if is_focused then
                focused_workspace = workspace_id
              end
            end
          end
        end
      end

      -- Update current focused workspace immediately
      current_focused_workspace = focused_workspace

      -- Get workspaces with windows
      sbar.exec("aerospace list-workspaces --monitor focused --empty no", function(non_empty_output)
        local workspace_ids_with_windows = {}

        if non_empty_output and non_empty_output ~= "" then
          for line in non_empty_output:gmatch("[^\r\n]+") do
            local workspace_id = tonumber(line:match("^%s*(.-)%s*$"))
            if workspace_id and workspace_id > 0 then
              workspace_ids_with_windows[workspace_id] = true
            end
          end
        end

        -- Create list of workspaces to show (with windows OR focused) - EXACT ORIGINAL LOGIC
        local workspaces_to_show = {}
        local workspace_set = {}

        for _, workspace_data in ipairs(all_workspace_data) do
          local workspace_id = workspace_data.id
          local should_show = workspace_ids_with_windows[workspace_id] or workspace_data.focused

          if should_show and not workspace_set[workspace_id] then
            workspace_set[workspace_id] = true
            table.insert(workspaces_to_show, workspace_id)
          end
        end

        -- Sort workspace IDs to maintain consistent order
        table.sort(workspaces_to_show)

        -- Clean up removed workspaces and create new ones
        cleanup_removed_workspaces(workspaces_to_show)

        for _, workspace_id in ipairs(workspaces_to_show) do
          if not spaces[workspace_id] then
            create_space(workspace_id)
          end
          -- Update app icons for each workspace
          update_workspace_apps(workspace_id)
        end

        -- Enhanced highlighting animation with modern effects
        for workspace_id, space in pairs(spaces) do
          local selected = workspace_id == current_focused_workspace

          sbar.animate("tanh", config.animation_duration, function()
            space:set({
              icon = { 
                highlight = selected,
                color = selected and colors.accent.primary or colors.white
              },
              label = { highlight = selected },
              background = {
                border_color = selected and colors.with_alpha(colors.accent.primary, 0.8) or colors.with_alpha(colors.grey, 0.25),
                color = selected and colors.with_alpha(colors.accent.primary, 0.12) or colors.bg1,
                shadow = { drawing = selected and config.modern_styling }
              }
            })

            if space.bracket then
              space.bracket:set({
                background = { 
                  border_color = selected and colors.with_alpha(colors.accent.primary, 0.3) or colors.with_alpha(colors.white, 0.08),
                  shadow = { drawing = selected and config.modern_styling }
                }
              })
            end
          end)
        end
      end)
    end)
  end)
end

-- Initialize with enhanced error handling
local function initialize()
  pcall(update_workspaces) -- Wrap in pcall for error resilience
end

initialize()

-- Enhanced window observer with improved event handling
local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Enhanced workspace change handler with immediate feedback
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  local focused_id = tonumber(env.FOCUSED_WORKSPACE)
  
  if focused_id == current_focused_workspace then
    return
  end
  
  local old_focused = current_focused_workspace
  current_focused_workspace = focused_id
  
  -- Immediate visual feedback for existing spaces
  for workspace_id, space in pairs(spaces) do
    local selected = workspace_id == focused_id
    local was_selected = workspace_id == old_focused
    
    -- Only animate if state actually changed
    if selected ~= was_selected then
      sbar.animate("tanh", config.hover_animation_duration, function()
        space:set({
          icon = { 
            highlight = selected,
            color = selected and colors.accent.primary or colors.white
          },
          label = { highlight = selected },
          background = { 
            border_color = selected and colors.with_alpha(colors.accent.primary, 0.8) or colors.with_alpha(colors.grey, 0.25),
            color = selected and colors.with_alpha(colors.accent.primary, 0.12) or colors.bg1,
            shadow = { drawing = selected and config.modern_styling }
          }
        })
        
        if space.bracket then
          space.bracket:set({
            background = { 
              border_color = selected and colors.with_alpha(colors.accent.primary, 0.3) or colors.with_alpha(colors.white, 0.08),
              shadow = { drawing = selected and config.modern_styling }
            }
          })
        end
      end)
    end
  end
  
  -- Clear cache and update workspaces
  cache.clear("workspace_")
  update_workspaces()
end)

-- Optimized window event handlers
space_window_observer:subscribe("window_focus", function(env)
  cache.clear("workspace_apps_")
  update_workspaces()
end)

space_window_observer:subscribe("space_windows_change", function(env)
  cache.clear("workspace_apps_")
  update_workspaces()
end)

-- Add spaces indicator AFTER the spaces are created (so it appears after them)
local spaces_indicator = sbar.add("item", {
  position = "left",
  padding_left = 5,
  padding_right = 2,
  icon = {
    padding_left = 10,
    padding_right = 10,
    color = colors.grey,
    string = icons.switch.on,
    font = { size = 14 }
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 10,
    string = "Workspaces",
    color = colors.white,
    font = { 
      size = 12,
      style = settings.font.style_map["Semibold"]
    }
  },
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
    corner_radius = 8,
    height = 24
  }
})

-- Enhanced indicator interactions
spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  sbar.animate("tanh", config.hover_animation_duration, function()
    spaces_indicator:set({
      icon = { 
        string = currently_on and icons.switch.off or icons.switch.on,
        color = currently_on and colors.accent.error or colors.grey
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", config.hover_animation_duration, function()
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.grey, 0.15),
        border_color = colors.with_alpha(colors.white, 0.2),
      },
      icon = { color = colors.white },
      label = {
        width = "dynamic",
        string = "Workspaces"
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", config.hover_animation_duration, function()
    spaces_indicator:set({
      background = {
        color = colors.transparent,
        border_color = colors.transparent,
      },
      icon = { color = colors.grey },
      label = { 
        width = 0,
        string = "Workspaces"
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

-- Enhanced system wake handler with staggered updates
sbar.add("item", {
  drawing = false,
  updates = true,
}):subscribe("system_woke", function()
  cache.clear() -- Clear all cache on wake
  sbar.delay(300, function() -- Reduced delay for faster wake response
    update_workspaces()
  end)
end)
