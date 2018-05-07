circle = 1.0 - add_modulo(
  lfo_triangle(17000),
  ((lfo_triangle(7973) * 4.0) + 1.0) * (triangle(lamp_phase))
);

cubed = circle * circle * circle;

strip(
  116,
  4,
  [0.5, 0.5, 0.5] * cubed * add_modulo(
    lfo_triangle([19000, 19150, 18852]),
    lamp_phase
  )
);
