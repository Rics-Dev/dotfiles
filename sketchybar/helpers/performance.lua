local cache = require("helpers.cache")

local M = {}

local performance_stats = {
  update_count = 0,
  last_update = 0,
  avg_update_time = 0,
  memory_usage = 0,
}

function M.start_timing()
  return os.clock()
end

function M.end_timing(start_time, operation)
  local duration = os.clock() - start_time
  performance_stats.last_update = duration
  performance_stats.update_count = performance_stats.update_count + 1
  performance_stats.avg_update_time = (performance_stats.avg_update_time + duration) / 2
  
  if os.getenv("SKETCHYBAR_DEBUG") then
    print(string.format("%s took %.2fms", operation, duration * 1000))
  end
  
  return duration
end

function M.get_stats()
  local cache_stats = cache.get_stats()
  return {
    performance = performance_stats,
    cache = cache_stats,
    cache_hit_ratio = cache_stats.hits / math.max(1, cache_stats.hits + cache_stats.misses)
  }
end

-- Cleanup old performance data
function M.cleanup()
  cache.cleanup()
  collectgarbage("collect")
end

return M

