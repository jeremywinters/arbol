circle = 1.0 - add_modulo(
  lfo_triangle(17000),
  ((lfo_triangle(7973) * 4.0) + 1.0) * (triangle(lamp_phase))
);

strip(
  64,
  4,
  gamma(
    [0.5, 0.5, 0.5] * circle * circle * add_modulo(
      lfo_triangle([8000, 69842, 12712]),
      lamp_phase
    )
  )
);
