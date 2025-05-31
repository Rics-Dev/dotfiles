local colors = require("colors")

sbar.bar({
  height = 42,
  color = colors.bar.bg,
  padding_right = 4,
  padding_left = 4,
  corner_radius = 12,
  border_width = 1,
  border_color = colors.bar.border,
  -- Disable shadow for faster transitions
  shadow = {
    drawing = false,
  },
  margin = 6,
  y_offset = 4,
  position = "top",
  sticky = true,
  topmost = "window",
  -- Add these properties for faster fullscreen transitions
  hidden = "off",
  display = "main",
  blur_radius = 0, -- Disable blur for performance
})
