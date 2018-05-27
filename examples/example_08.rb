# strip(
#   512,
#   11,
#   feedback(
#     triangle(phasor([9312, 9200, 5342])) * one_pixel(
#       add_modulo(
#         triangle(phasor(25000)),
#         lamp_phase
#       )
#     ),
#     0.96
#   )
# )

strip(
  512,
  11,
  feedback(
    gamma(
      [0.5, 1.0, 1.0] * triangle(phasor([3321, 3134, 4515])) * less_than(
        add_modulo(lamp_phase, phasor(6999)),
        0.025
      )
    ),
    0.94
  )
)