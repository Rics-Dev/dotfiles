local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local cache = require("helpers.cache")
local throttle = require("helpers.throttle")

local config = {
	animation_duration = 4, -- Reduced from 8 for faster transitions
	hover_animation_duration = 4, -- Reduced from 8
	max_app_icons = 6,
	icon_spacing = " ",
	update_throttle = 0.05, -- Reduced from 0.1 for more responsive updates
	cache_ttl = 2,
	workspace_padding = 3,
	modern_styling = false, -- Disable for performance in fullscreen
	disable_shadows_in_fullscreen = true, -- New option
}

local spaces = {}
local current_focused_workspace = nil

-- Helper function to validate workspace ID (now supports letters and numbers)
local function is_valid_workspace_id(workspace_str)
	if not workspace_str or workspace_str == "" then
		return false
	end
	-- Allow single letters (a-z, A-Z) or numbers (1-9, 10+)
	return workspace_str:match("^[a-zA-Z]$") or workspace_str:match("^%d+$")
end

-- Helper function to get display string for workspace
local function get_workspace_display(workspace_id)
	return tostring(workspace_id)
end

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
				style = settings.font.style_map["Bold"],
			},
			string = get_workspace_display(workspace_id),
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
				angle = 270,
			},
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
				angle = 270,
			},
		},
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
						shadow = { drawing = true },
					},
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
							shadow = { drawing = config.modern_styling },
						},
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
						shadow = { drawing = true },
					},
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
						shadow = { drawing = false },
					},
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

	sbar.exec(
		"aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'",
		function(windows_output)
			local icon_line = ""

			if windows_output and windows_output ~= "" then
				local seen_apps = {}
				local app_list = {}
				local icon_count = 0

				-- Parse and deduplicate app names with limit
				for app_name in windows_output:gmatch("[^\r\n]+") do
					app_name = app_name:match("^%s*(.-)%s*$") -- trim whitespace
					if
						app_name
						and app_name ~= ""
						and not seen_apps[app_name]
						and icon_count < config.max_app_icons
					then
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
		end
	)
end

-- Enhanced workspace sorting function (numbers first, then letters)
local function sort_workspaces(workspace_list)
	table.sort(workspace_list, function(a, b)
		local a_is_num = tonumber(a) ~= nil
		local b_is_num = tonumber(b) ~= nil
		
		-- Numbers come before letters
		if a_is_num and not b_is_num then
			return true
		elseif not a_is_num and b_is_num then
			return false
		elseif a_is_num and b_is_num then
			-- Both numbers, sort numerically
			return tonumber(a) < tonumber(b)
		else
			-- Both letters, sort alphabetically
			return tostring(a) < tostring(b)
		end
	end)
	return workspace_list
end

local function update_workspaces()
	throttle("update_workspaces", config.update_throttle, function()
		sbar.exec(
			"aerospace list-workspaces --monitor focused --format '%{workspace}:%{workspace-is-focused}'",
			function(all_workspaces_output)
				local focused_workspace = nil
				local all_workspace_data = {}

				-- Parse all workspace data (now supports letters and numbers)
				if all_workspaces_output and all_workspaces_output ~= "" then
					for line in all_workspaces_output:gmatch("[^\r\n]+") do
						local workspace_str, is_focused_str = line:match("^%s*(.-):(.*)")
						if workspace_str and is_focused_str then
							workspace_str = workspace_str:match("^%s*(.-)%s*$") -- trim whitespace
							local is_focused = is_focused_str:match("true") ~= nil

							if is_valid_workspace_id(workspace_str) then
								table.insert(all_workspace_data, { id = workspace_str, focused = is_focused })
								if is_focused then
									focused_workspace = workspace_str
								end
							end
						end
					end
				end

				-- Update current focused workspace immediately
				current_focused_workspace = focused_workspace

				-- Get workspaces with windows (now supports letters and numbers)
				sbar.exec("aerospace list-workspaces --monitor focused --empty no", function(non_empty_output)
					local workspace_ids_with_windows = {}

					if non_empty_output and non_empty_output ~= "" then
						for line in non_empty_output:gmatch("[^\r\n]+") do
							local workspace_str = line:match("^%s*(.-)%s*$")
							if is_valid_workspace_id(workspace_str) then
								workspace_ids_with_windows[workspace_str] = true
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

					-- CRITICAL FIX: Sort workspace IDs BEFORE processing them
					workspaces_to_show = sort_workspaces(workspaces_to_show)

					-- Clean up removed workspaces first
					cleanup_removed_workspaces(workspaces_to_show)

					-- Check if we need to reorder existing workspaces
					local existing_order = {}
					for workspace_id in pairs(spaces) do
						table.insert(existing_order, workspace_id)
					end
					existing_order = sort_workspaces(existing_order)

					local needs_reorder = false
					-- Check if current order matches desired order
					if #existing_order ~= #workspaces_to_show then
						needs_reorder = true
					else
						for i, workspace_id in ipairs(workspaces_to_show) do
							if existing_order[i] ~= workspace_id then
								needs_reorder = true
								break
							end
						end
					end

					-- If order changed, recreate all workspaces in correct order
					if needs_reorder then
						-- Store current workspace states
						local workspace_states = {}
						for workspace_id, space in pairs(spaces) do
							workspace_states[workspace_id] = {
								icon_highlight = space:query().icon.highlight,
								label_highlight = space:query().label.highlight,
							}
						end

						-- Remove all existing workspaces
						for workspace_id, space in pairs(spaces) do
							if space.bracket then
								sbar.remove(space.bracket.name)
							end
							sbar.remove("space.padding." .. workspace_id)
							sbar.remove("space." .. workspace_id)
						end
						spaces = {}

						-- Recreate workspaces in sorted order
						for _, workspace_id in ipairs(workspaces_to_show) do
							create_space(workspace_id)
							update_workspace_apps(workspace_id)
						end
					else
						-- Just create new workspaces if no reordering needed
						for _, workspace_id in ipairs(workspaces_to_show) do
							if not spaces[workspace_id] then
								create_space(workspace_id)
							end
							update_workspace_apps(workspace_id)
						end
					end

					-- Enhanced highlighting animation with modern effects
					-- Process in sorted order again to ensure consistent visual state
					local sorted_existing_workspaces = {}
					for workspace_id in pairs(spaces) do
						table.insert(sorted_existing_workspaces, workspace_id)
					end
					sorted_existing_workspaces = sort_workspaces(sorted_existing_workspaces)

					for _, workspace_id in ipairs(sorted_existing_workspaces) do
						local space = spaces[workspace_id]
						if space then
							local selected = workspace_id == current_focused_workspace

							sbar.animate("tanh", config.animation_duration, function()
								space:set({
									icon = {
										highlight = selected,
										color = selected and colors.accent.primary or colors.white,
									},
									label = { highlight = selected },
									background = {
										border_color = selected and colors.with_alpha(colors.accent.primary, 0.8)
											or colors.with_alpha(colors.grey, 0.25),
										color = selected and colors.with_alpha(colors.accent.primary, 0.12) or colors.bg1,
										shadow = { drawing = selected and config.modern_styling },
									},
								})

								if space.bracket then
									space.bracket:set({
										background = {
											border_color = selected and colors.with_alpha(colors.accent.primary, 0.3)
												or colors.with_alpha(colors.white, 0.08),
											shadow = { drawing = selected and config.modern_styling },
										},
									})
								end
							end)
						end
					end
				end)
			end
		)
	end)
end

local function initialize()
	pcall(update_workspaces) -- Create workspaces first
end

initialize()

-- Enhanced window observer with improved event handling
local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Enhanced workspace change handler with immediate feedback
space_window_observer:subscribe("aerospace_workspace_change", function(env)
	local focused_id = env.FOCUSED_WORKSPACE -- Keep as string to support letters

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
						color = selected and colors.accent.primary or colors.white,
					},
					label = { highlight = selected },
					background = {
						border_color = selected and colors.with_alpha(colors.accent.primary, 0.8)
							or colors.with_alpha(colors.grey, 0.25),
						color = selected and colors.with_alpha(colors.accent.primary, 0.12) or colors.bg1,
						shadow = { drawing = selected and config.modern_styling },
					},
				})

				if space.bracket then
					space.bracket:set({
						background = {
							border_color = selected and colors.with_alpha(colors.accent.primary, 0.3)
								or colors.with_alpha(colors.white, 0.08),
							shadow = { drawing = selected and config.modern_styling },
						},
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
