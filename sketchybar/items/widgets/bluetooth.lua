local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

-- Bluetooth icons - using simple approach since icons module might not have bluetooth yet
local bt_icon = {
  connected = "􀟜", -- SF Symbol bluetooth.fill
  disconnected = "􀟝", -- SF Symbol bluetooth.slash.fill
}

local bluetooth = sbar.add("item", "widgets.bluetooth", {
  position = "right",
  icon = {
    string = bt_icon.disconnected,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
    color = colors.grey,
  },
  label = { drawing = false },
  update_freq = 10,
  popup = { align = "center" }
})

-- Popup header
local bluetooth_header = sbar.add("item", {
  position = "popup." .. bluetooth.name,
  icon = {
    string = "Bluetooth Devices",
    font = {
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.white,
  },
  label = { drawing = false },
  width = popup_width,
  align = "center",
  background = {
    height = 2,
    color = colors.grey,
    y_offset = -15
  }
})

-- Bluetooth status item
local bluetooth_status = sbar.add("item", {
  position = "popup." .. bluetooth.name,
  icon = {
    align = "left",
    string = "Status:",
    width = popup_width / 2,
  },
  label = {
    string = "Unknown",
    width = popup_width / 2,
    align = "right",
  }
})

-- Function to update bluetooth status
local function update_bluetooth_status()
  -- Use blueutil for more reliable status checking
  sbar.exec("which blueutil", function(blueutil_check)
    if blueutil_check and blueutil_check ~= "" then
      -- Use blueutil if available
      sbar.exec("blueutil -p", function(power_status)
        local is_on = power_status and power_status:match("1") ~= nil
        
        bluetooth:set({
          icon = {
            string = is_on and bt_icon.connected or bt_icon.disconnected,
            color = is_on and colors.blue or colors.grey
          }
        })
        
        bluetooth_status:set({
          label = {
            string = is_on and "On" or "Off",
            color = is_on and colors.green or colors.red
          }
        })
        
        if is_on then
          -- Get connected devices using blueutil
          sbar.exec("blueutil --connected", function(devices)
            -- Safe remove - only remove if items exist
            local items_to_remove = {"bluetooth.device.0", "bluetooth.device.1", "bluetooth.device.2", "bluetooth.device.3", "bluetooth.device.4", "bluetooth.device.none"}
            for _, item in ipairs(items_to_remove) do
              pcall(function() sbar.remove(item) end)
            end
            
            if devices and devices ~= "" then
              local device_count = 0
              for device in devices:gmatch("[^\r\n]+") do
                if device and device ~= "" and device_count < 5 then
                  -- Parse device info (format: "address, name, connected")
                  local name = device:match("^[^,]+,%s*([^,]+)")
                  if name then
                    sbar.add("item", "bluetooth.device." .. device_count, {
                      position = "popup." .. bluetooth.name,
                      icon = {
                        string = "🎧", -- Generic device icon
                        width = 30,
                        align = "left"
                      },
                      label = {
                        string = name,
                        width = popup_width - 30,
                        align = "left",
                        color = colors.white
                      }
                    })
                    device_count = device_count + 1
                  end
                end
              end
              
              if device_count == 0 then
                -- No devices connected
                sbar.add("item", "bluetooth.device.none", {
                  position = "popup." .. bluetooth.name,
                  icon = { drawing = false },
                  label = {
                    string = "No devices connected",
                    width = popup_width,
                    align = "center",
                    color = colors.grey
                  }
                })
              end
            else
              -- No devices connected
              sbar.add("item", "bluetooth.device.none", {
                position = "popup." .. bluetooth.name,
                icon = { drawing = false },
                label = {
                  string = "No devices connected",
                  width = popup_width,
                  align = "center",
                  color = colors.grey
                }
              })
            end
          end)
        else
          -- Remove device items when bluetooth is off
          local items_to_remove = {"bluetooth.device.0", "bluetooth.device.1", "bluetooth.device.2", "bluetooth.device.3", "bluetooth.device.4", "bluetooth.device.none"}
          for _, item in ipairs(items_to_remove) do
            pcall(function() sbar.remove(item) end)
          end
        end
      end)
    else
      -- Fallback to system_profiler if blueutil not available
      sbar.exec("defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null || echo '0'", function(power_status)
        local is_on = power_status and power_status:match("1") ~= nil
        
        bluetooth:set({
          icon = {
            string = is_on and bt_icon.connected or bt_icon.disconnected,
            color = is_on and colors.blue or colors.grey
          }
        })
        
        bluetooth_status:set({
          label = {
            string = is_on and "On" or "Off",
            color = is_on and colors.green or colors.red
          }
        })
        
        -- Safe remove for fallback method too
        local items_to_remove = {"bluetooth.device.0", "bluetooth.device.1", "bluetooth.device.2", "bluetooth.device.3", "bluetooth.device.4", "bluetooth.device.none"}
        for _, item in ipairs(items_to_remove) do
          pcall(function() sbar.remove(item) end)
        end
        
        if is_on then
          sbar.add("item", "bluetooth.device.none", {
            position = "popup." .. bluetooth.name,
            icon = { drawing = false },
            label = {
              string = "Install 'blueutil' for device info",
              width = popup_width,
              align = "center",
              color = colors.orange
            }
          })
        end
      end)
    end
  end)
end

-- Function to toggle bluetooth popup
local function toggle_bluetooth_details()
  local should_draw = bluetooth:query().popup.drawing == "off"
  if should_draw then
    bluetooth:set({ popup = { drawing = true } })
    update_bluetooth_status()
  else
    bluetooth:set({ popup = { drawing = false } })
    local items_to_remove = {"bluetooth.device.0", "bluetooth.device.1", "bluetooth.device.2", "bluetooth.device.3", "bluetooth.device.4", "bluetooth.device.none"}
    for _, item in ipairs(items_to_remove) do
      pcall(function() sbar.remove(item) end)
    end
  end
end

-- Function to hide bluetooth popup
local function hide_bluetooth_details()
  bluetooth:set({ popup = { drawing = false } })
  local items_to_remove = {"bluetooth.device.0", "bluetooth.device.1", "bluetooth.device.2", "bluetooth.device.3", "bluetooth.device.4", "bluetooth.device.none"}
  for _, item in ipairs(items_to_remove) do
    pcall(function() sbar.remove(item) end)
  end
end

-- Function to toggle bluetooth on/off (requires blueutil: brew install blueutil)
local function toggle_bluetooth_power()
  sbar.exec("which blueutil", function(result)
    if result and result ~= "" then
      sbar.exec("blueutil -p", function(status)
        local current_state = status and status:match("1") ~= nil
        local new_state = current_state and "0" or "1"
        sbar.exec("blueutil -p " .. new_state, function()
          -- Wait a moment for the change to take effect
          sbar.delay(1, update_bluetooth_status)
        end)
      end)
    else
      -- Fallback: open Bluetooth preferences
      sbar.exec("open /System/Library/PreferencePanes/Bluetooth.prefpane")
    end
  end)
end

-- Subscribe to events
bluetooth:subscribe({"routine", "system_woke"}, update_bluetooth_status)
bluetooth:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    toggle_bluetooth_power()
  else
    toggle_bluetooth_details()
  end
end)

bluetooth:subscribe("mouse.exited.global", hide_bluetooth_details)

-- Add bracket for styling
sbar.add("bracket", "widgets.bluetooth.bracket", { bluetooth.name }, {
  background = { color = colors.bg1 }
})

-- Add padding
sbar.add("item", "widgets.bluetooth.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Initial update
update_bluetooth_status()
