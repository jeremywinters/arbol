circle = 1.0 - add_modulo(
  lfo_triangle(17000),
  ((lfo_triangle(9231) * 4.0) + 1.0) * (triangle(lamp_phase))
);

strip(
  512,
  4,
  gamma(
    [0.7, 0.6, 1.0] * circle * add_modulo(
      lfo_triangle([14333, 14555, 17999]),
      lamp_phase
    )
  )
);
