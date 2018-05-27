strip(
  512,
  11,
  feedback(
    gamma(
      0.7 * add_modulo(
        lamp_phase, 
        phasor(8000)
      ) * lfo_triangle(
        [14000,13613,13131]
      )
    ),
    0.995
  )
)