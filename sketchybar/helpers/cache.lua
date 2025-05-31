local cache = {}
local cache_ttl = {}
local cache_stats = { hits = 0, misses = 0, memory_usage = 0 }
local cache_config = {
  max_size = 1000,
  default_ttl = 30,
  cleanup_threshold = 0.8
}

local M = {}

function M.get(key, ttl)
  ttl = ttl or 5
  if cache[key] and cache_ttl[key] and (os.time() - cache_ttl[key] < ttl) then
    cache_stats.hits = cache_stats.hits + 1
    return cache[key]
  end
  cache_stats.misses = cache_stats.misses + 1
  return nil
end

-- Memory-aware caching with automatic cleanup
function M.set(key, value, ttl)
  ttl = ttl or cache_config.default_ttl
  
  -- Auto-cleanup when cache gets too large
  if #cache > cache_config.max_size * cache_config.cleanup_threshold then
    M.cleanup(true) -- Force cleanup
  end
  
  cache[key] = value
  cache_ttl[key] = os.time() + ttl
  cache_stats.memory_usage = cache_stats.memory_usage + 1
end


function M.clear(pattern)
  if pattern then
    for k, _ in pairs(cache) do
      if k:match(pattern) then
        cache[k] = nil
        cache_ttl[k] = nil
      end
    end
  else
    cache = {}
    cache_ttl = {}
  end
end

function M.get_stats()
  return cache_stats
end

function M.cleanup(force)
  local current_time = os.time()
  local removed = 0
  local priority_keys = {}
  for k, time in pairs(cache_ttl) do
    if force or current_time > time then
      cache[k] = nil
      cache_ttl[k] = nil
      removed = removed + 1
    end
  end
  
  cache_stats.memory_usage = math.max(0, cache_stats.memory_usage - removed)
  return removed
end

return M
