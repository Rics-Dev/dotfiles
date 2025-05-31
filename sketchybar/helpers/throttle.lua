local timers = {}

local function throttle(key, delay, callback)
  if timers[key] then
    return -- Already scheduled
  end
  timers[key] = true
  sbar.delay(delay, function()
    timers[key] = nil
    callback()
  end)
end

return throttle
