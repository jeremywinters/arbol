x = lfo_triangle(
  [1000,1313,1213]
);

y = times(
  x,
  lfo_triangle(2889)
);

strip(
  100,
  1,
  times(x,y)
);