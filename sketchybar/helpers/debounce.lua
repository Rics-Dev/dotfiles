 local timers = {}

local function debounce(key, delay, callback)
  if timers[key] then
    timers[key]:cancel()
  end
  
  timers[key] = sbar.delay(delay, function()
    timers[key] = nil
    callback()
  end)
end

return debounce
