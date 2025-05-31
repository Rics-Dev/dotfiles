-- colors.lua
return {
  -- Core colors with better contrast
  black = 0xff0f0f0f,
  white = 0xffe8e8e9,
  red = 0xffff6b88,
  green = 0xff96d672,
  blue = 0xff7dd3fc,
  yellow = 0xffffd93d,
  orange = 0xffff9f43,
  magenta = 0xffc678dd,
  grey = 0xff8b8d98,
  transparent = 0x00000000,

  -- Enhanced bar design with subtle gradients
  bar = {
    bg = 0xf01e1e2e,
    border = 0xff313244,
    shadow = 0x44000000,
  },
  -- Modern popup design
  popup = {
    bg = 0xe01e1e2e,
    border = 0xff45475a,
    shadow = 0x88000000,
  },
  -- Gradient backgrounds
  bg1 = 0xff2a2d3a,
  bg2 = 0xff363a4f,
  bg3 = 0xff414559,
  -- Accent colors for different states
  accent = {
    primary = 0xff89b4fa,
    secondary = 0xfff5c2e7,
    success = 0xffa6e3a1,
    warning = 0xfff9e2af,
    error = 0xfff38ba8,
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
  -- New gradient function for modern effects
  create_gradient = function(color1, color2, steps)
    local gradients = {}
    for i = 0, steps - 1 do
      local alpha = i / (steps - 1)
      local r1, g1, b1 = (color1 >> 16) & 0xff, (color1 >> 8) & 0xff, color1 & 0xff
      local r2, g2, b2 = (color2 >> 16) & 0xff, (color2 >> 8) & 0xff, color2 & 0xff
      local r = math.floor(r1 + (r2 - r1) * alpha)
      local g = math.floor(g1 + (g2 - g1) * alpha)
      local b = math.floor(b1 + (b2 - b1) * alpha)
      table.insert(gradients, 0xff000000 | (r << 16) | (g << 8) | b)
    end
    return gradients
  end,
}
