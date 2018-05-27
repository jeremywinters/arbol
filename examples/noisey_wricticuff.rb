mask = triangle(
  add_modulo(
    lamp_phase,
    (3.0 * lfo_triangle(13000)) * triangle(phasor(25000))
  )
);

strip(
  48,
  4,
  feedback(
    gamma(mask * mask * mask * (noise_pixel > 0.95) * [1.0, 0.0, 1.0] * lfo_triangle([9000, 11011, 13181])),
    0.86
  )
)