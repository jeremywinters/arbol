class Gamma < Base
  Arbol.add_mapped_class(
    'gamma', 
    Gamma,
%{long neopix_gamma[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 18, 20, 22, 24, 26, 28, 31, 33, 36, 39, 42, 45, 48, 51, 55, 59, 62, 66, 71, 75, 79, 84, 89, 94, 99, 104, 110, 116, 122, 128, 134, 140, 147, 154, 161, 168, 176, 184, 192, 200, 208, 217, 225, 234, 244, 253, 263, 273, 283, 293, 304, 315, 326, 338, 349, 361, 373, 386, 398, 411, 425, 438, 452, 466, 480, 495, 510, 525, 541, 556, 572, 589, 605, 622, 640, 657, 675, 693, 712, 730, 750, 769, 789, 809, 829, 850, 871, 892, 914, 936, 959, 981, 1004, 1028, 1052, 1076, 1100, 1125, 1150, 1176, 1202, 1228, 1255, 1282, 1309, 1337, 1365, 1393, 1422, 1452, 1481, 1511, 1542, 1572, 1604, 1635, 1667, 1700, 1733, 1766, 1799, 1833, 1868, 1903, 1938, 1974, 2010, 2046, 2083, 2121, 2158, 2197, 2235, 2274, 2314, 2354, 2394, 2435, 2476, 2518, 2560, 2603, 2646, 2690, 2734, 2778, 2823, 2869, 2915, 2961, 3008, 3055, 3103, 3151, 3200, 3249, 3299, 3349, 3399, 3451, 3502, 3554, 3607, 3660, 3714, 3768, 3823, 3878, 3933, 3990, 4046, 4103, 4161, 4219, 4278, 4337, 4397, 4458, 4518, 4580, 4642, 4704, 4767, 4831, 4895, 4959, 5025, 5090, 5157, 5223, 5291, 5359, 5427, 5496, 5566, 5636, 5707, 5778, 5850, 5922, 5995, 6069, 6143, 6218, 6293, 6369, 6446, 6523, 6601, 6679, 6758, 6837, 6917, 6998, 7079, 7161, 7244, 7327, 7410, 7495, 7580, 7665, 7751, 7838, 7926, 8014, 8102};
  
long INTEGER_SCALE_MINUS_ONE = INTEGER_SCALE - 1;
void gamma(long input[3], long out[3]) {
  out[0] = neopix_gamma[map(input[0], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
  out[1] = neopix_gamma[map(input[1], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
  out[2] = neopix_gamma[map(input[2], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
}}
  )
  
  attr_accessor :input

  def initialize(params)
    super(params)
    @frame_optimized = false
  end

  def param_keys
    [:input]
  end
  
  def arduino_code
    [
      "gamma(#{@input.name}, #{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

module Arbol
  class Documentation

  def gamma  
%{--
### gamma(input)

* **input**

Returns gamma corrected input. This makes the colors look much better.

}
  end

  end
end

def gamma(input)
  h = ArbolHash.new
  h[:type] = 'gamma'
  h[:input] = resolve(input)
  h
end