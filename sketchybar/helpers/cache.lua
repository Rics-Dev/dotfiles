local cache = {}
local cache_ttl = {}
local cache_stats = { hits = 0, misses = 0 }

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

function M.set(key, value)
  cache[key] = value
  cache_ttl[key] = os.time()
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

-- Cleanup old entries periodically
function M.cleanup()
  local current_time = os.time()
  local removed = 0
  for k, time in pairs(cache_ttl) do
    if current_time - time > 300 then -- 5 minutes
      cache[k] = nil
      cache_ttl[k] = nil
      removed = removed + 1
    end
  end
  return removed
end

return M
