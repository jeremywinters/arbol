strip(
  512,
  11,
  feedback_offset(
    gamma(
      (noise_pixel > 0.996) * lfo_triangle([9991, 12151, 12416]) * [0.5, 0.5, 1.0]),
    0.93,
    0.01
  )
)