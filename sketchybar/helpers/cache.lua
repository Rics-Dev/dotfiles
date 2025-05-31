local cache = {}
local cache_ttl = {}

local M = {}

function M.get(key, ttl)
  ttl = ttl or 5
  if cache[key] and cache_ttl[key] and (os.time() - cache_ttl[key] < ttl) then
    return cache[key]
  end
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

return M
