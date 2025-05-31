local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local current_focused_workspace = nil

-- Enhanced space creation with better styling
local function create_space(workspace_id)
  if spaces[workspace_id] then
    return spaces[workspace_id]
  end

  local space = sbar.add("space", "space." .. workspace_id, {
    space = workspace_id,
    icon = {
      font = { family = settings.font.numbers },
      string = tostring(workspace_id),
      padding_left = 12,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 15,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 2,
    padding_left = 2,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.with_alpha(colors.grey, 0.3),
      corner_radius = 8,
    },
  })

  spaces[workspace_id] = space

  -- Enhanced bracket with smoother appearance
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.with_alpha(colors.white, 0.1),
      height = 30,
      border_width = 1,
      corner_radius = 10
    }
  })

  space.bracket = space_bracket

  -- Space padding
  sbar.add("space", "space.padding." .. workspace_id, {
    space = workspace_id,
    script = "",
    width = 5,
  })

  -- Enhanced click handling with faster animation
  space:subscribe("mouse.clicked", function(env)
    if workspace_id ~= current_focused_workspace then
      sbar.exec("aerospace workspace " .. workspace_id)
      -- Faster visual feedback (reduced from 30 to 15)
      sbar.animate("tanh", 15, function()
        space:set({
          background = { 
            color = colors.with_alpha(colors.white, 0.08),
            border_color = colors.with_alpha(colors.white, 0.4)
          }
        })
      end)
      sbar.delay(100, function() -- Reduced from 200 to 100
        sbar.animate("tanh", 15, function()
          space:set({
            background = { 
              color = colors.bg1,
              border_color = colors.with_alpha(colors.grey, 0.3)
            }
          })
        end)
      end)
    end
  end)

  -- Faster hover effects
  space:subscribe("mouse.entered", function(_)
    if workspace_id ~= current_focused_workspace then
      sbar.animate("tanh", 15, function() -- Reduced from 30 to 15
        space:set({
          background = { 
            border_color = colors.with_alpha(colors.white, 0.2),
            color = colors.with_alpha(colors.white, 0.03)
          }
        })
      end)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    if workspace_id ~= current_focused_workspace then
      sbar.animate("tanh", 15, function() -- Reduced from 30 to 15
        space:set({
          background = { 
            border_color = colors.with_alpha(colors.grey, 0.3),
            color = colors.bg1
          }
        })
      end)
    end
  end)

  return space
end

-- Clean up removed workspaces (only remove unused ones)
local function cleanup_removed_workspaces(active_workspace_ids)
  local active_set = {}
  for _, id in ipairs(active_workspace_ids) do
    active_set[id] = true
  end
  
  for workspace_id, space in pairs(spaces) do
    if not active_set[workspace_id] then
      if space.bracket then
        sbar.remove(space.bracket.name)
      end
      sbar.remove("space.padding." .. workspace_id)
      sbar.remove(space.name)
      spaces[workspace_id] = nil
    end
  end
end

-- Get app icons for workspace with proper deduplication
local function update_workspace_apps(workspace_id)
  sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'", function(windows_output)
    local icon_line = ""

    if windows_output and windows_output ~= "" then
      local seen_apps = {}
      local app_list = {}

      -- Parse and deduplicate app names
      for app_name in windows_output:gmatch("[^\r\n]+") do
        app_name = app_name:match("^%s*(.-)%s*$") -- trim whitespace
        if app_name and app_name ~= "" and not seen_apps[app_name] then
          seen_apps[app_name] = true
          table.insert(app_list, app_name)
        end
      end

      -- Build icon string from unique apps
      for _, app_name in ipairs(app_list) do
        local icon = app_icons[app_name] or app_icons["Default"] or "●"
        icon_line = icon_line .. icon .. " " -- Add space between icons for better readability
      end

      -- Remove trailing space
      icon_line = icon_line:match("^%s*(.-)%s*$") or ""
    end
    
    local space = spaces[workspace_id]
    if space then
      space:set({
        label = { string = icon_line }
      })
    end
  end)
end

-- FIXED: Get workspaces with windows OR focused workspace only - with proper highlighting
local function update_workspaces()
  -- Get both focused and non-empty workspaces in a single efficient call
  sbar.exec("aerospace list-workspaces --monitor focused --format '%{workspace}:%{workspace-is-focused}'", function(all_workspaces_output)
    local focused_workspace = nil
    local all_workspace_data = {}

    -- Parse all workspace data at once
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

      -- Create list of workspaces to show (with windows OR focused)
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

      -- SMOOTHLY animate highlighting for all visible spaces after workspace updates
      for workspace_id, space in pairs(spaces) do
        local selected = workspace_id == current_focused_workspace

        sbar.animate("tanh", 15, function()
          space:set({
            icon = { highlight = selected },
            label = { highlight = selected },
            background = {
              border_color = selected and colors.with_alpha(colors.white, 0.6) or colors.with_alpha(colors.grey, 0.3),
              color = selected and colors.with_alpha(colors.white, 0.08) or colors.bg1
            }
          })

          if space.bracket then
            space.bracket:set({
              background = { border_color = selected and colors.with_alpha(colors.white, 0.2) or colors.with_alpha(colors.white, 0.1) }
            })
          end
        end)
      end
    end)
  end)
end

-- Initialize
update_workspaces()

-- Window observer
local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Spaces indicator with cleaner design
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
    font = { size = 12 }
  },
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
    corner_radius = 6
  }
})

-- Workspace change handler - OPTIMIZED with smooth animations
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  local focused_id = tonumber(env.FOCUSED_WORKSPACE)
  
  if focused_id == current_focused_workspace then
    return
  end
  
  current_focused_workspace = focused_id
  
  -- IMMEDIATELY animate highlighting for existing spaces
  for workspace_id, space in pairs(spaces) do
    local selected = workspace_id == focused_id
    
    sbar.animate("tanh", 15, function()
      space:set({
        icon = { highlight = selected },
        label = { highlight = selected },
        background = { 
          border_color = selected and colors.with_alpha(colors.white, 0.6) or colors.with_alpha(colors.grey, 0.3),
          color = selected and colors.with_alpha(colors.white, 0.08) or colors.bg1
        }
      })
      
      if space.bracket then
        space.bracket:set({
          background = { border_color = selected and colors.with_alpha(colors.white, 0.2) or colors.with_alpha(colors.white, 0.1) }
        })
      end
    end)
  end
  
  -- Update workspaces (this will show only workspaces with windows OR focused)
  update_workspaces()
end)

-- Window events to update workspaces when windows are created/destroyed
space_window_observer:subscribe("window_focus", function(env)
  update_workspaces() -- Removed delay for immediate response
end)

space_window_observer:subscribe("space_windows_change", function(env)
  update_workspaces() -- Removed delay for immediate response
end)

-- Enhanced spaces indicator interactions with faster animations
spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  sbar.animate("tanh", 15, function() -- Reduced from 30 to 15
    spaces_indicator:set({
      icon = { 
        string = currently_on and icons.switch.off or icons.switch.on,
        color = currently_on and colors.red or colors.grey
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 15, function() -- Reduced from 30 to 15
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.grey, 0.2),
        border_color = colors.with_alpha(colors.white, 0.1),
      },
      icon = { color = colors.bg1 },
      label = {
        width = "dynamic",
        string = "Workspaces"
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 15, function() -- Reduced from 30 to 15
    spaces_indicator:set({
      background = {
        color = colors.transparent,
        border_color = colors.transparent,
      },
      icon = { color = colors.grey },
      label = { 
        width = 0,
        string = "Spaces"
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

-- System wake handler
sbar.add("item", {
  drawing = false,
  updates = true,
}):subscribe("system_woke", function()
  sbar.delay(500, function() -- Reduced from 1000 to 500
    update_workspaces()
  end)
end)

