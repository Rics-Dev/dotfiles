local colors = require("colors")

sbar.bar({
  height = 42,
  color = colors.bar.bg,
  padding_right = 4,
  padding_left = 4,
  corner_radius = 12,
  border_width = 1,
  border_color = colors.bar.border,
  shadow = {
    drawing = true,
    color = colors.bar.shadow,
    distance = 8,
    angle = 270
  },
  margin = 6,
  y_offset = 4,
  position = "top",
  sticky = true,
  topmost = "window"
})
