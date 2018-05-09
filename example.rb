circle = 1.0 - add_modulo(
  lfo_triangle(17000),
  ((lfo_triangle(7973) * 4.0) + 1.0) * (triangle(lamp_phase))
);

# cubed = circle * circle * circle;

strip(
  256,
  4,
  gamma([0.5, 0.5, 0.5] * circle * add_modulo(
    lfo_triangle([4000, 6842, 7712]),
    lamp_phase
  ))
);
