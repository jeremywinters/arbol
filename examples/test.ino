
#include <Adafruit_NeoPixel.h>

#define INTEGER_SCALE 8192

long long_div(long numerator, long denominator)
{
  return (numerator * INTEGER_SCALE) / denominator;
}

long long_mult(long op1, long op2)
{
  return op1 * op2 / INTEGER_SCALE;
}

byte byte_mult(byte op1, byte op2)
{
  return (byte)((uint16_t)op1 * (uint16_t)op2 / (uint16_t)INTEGER_SCALE);
}

int neoPixelPin = 4;

// How many NeoPixels we will be using, charge accordingly
int pixelCount = 256;

// Instatiate the NeoPixel from the ibrary
Adafruit_NeoPixel strip = Adafruit_NeoPixel(pixelCount, neoPixelPin, NEO_GRB + NEO_KHZ800);

void setup() {
  strip.begin();
}

void loop() {
  calculate_strip();
  delay(10);
  //Serial.println('b');
  //strip.setPixelColor(1, strip.Color(233,0,0));
  //strip.show();
}

void calculate_strip() {
  long mils = millis();
  for (int i=0; i < pixelCount; i++) {
    long this_phase = long_div(i, pixelCount - 1);
// beginning of generated code


long Const_f794688614f14b11856e272da8292b19[3] = {8191,8191,8191};

long Const_6be0c95fd9094d91baff35eff8b6e3e4[3] = {17000,17000,17000};

long LFOTriangle_7c044b8a1c7e425a82ca76a053a0f909[3];
lfo_triangle(mils, Const_6be0c95fd9094d91baff35eff8b6e3e4, LFOTriangle_7c044b8a1c7e425a82ca76a053a0f909);

long Const_43d99e33af4647c0a0dbf67114040c19[3] = {7973,7973,7973};

long LFOTriangle_56e2a10e06764c739e9364fc0f2d30fd[3];
lfo_triangle(mils, Const_43d99e33af4647c0a0dbf67114040c19, LFOTriangle_56e2a10e06764c739e9364fc0f2d30fd);

long Const_274580b7e4ad41e6a3784ed505897f70[3] = {32764,32764,32764};

long Times_acc58c4e552641f09c342d854bf0b50d[3];
times(LFOTriangle_56e2a10e06764c739e9364fc0f2d30fd, Const_274580b7e4ad41e6a3784ed505897f70, Times_acc58c4e552641f09c342d854bf0b50d);

long Const_3eb6f35d94f54169814388f853e0ba82[3] = {8191,8191,8191};

long Add_2fbd653b6690489ca6a2082e6c456d7f[3];
add(Times_acc58c4e552641f09c342d854bf0b50d, Const_3eb6f35d94f54169814388f853e0ba82, Add_2fbd653b6690489ca6a2082e6c456d7f);

long LampPhase_378970824cc5417e8b77f823740eab9b[3] = {this_phase, this_phase, this_phase};

long PhaseTriangle_2aad8df0b1fd473480b73be3d544e048[3];
triangle(mils, LampPhase_378970824cc5417e8b77f823740eab9b, PhaseTriangle_2aad8df0b1fd473480b73be3d544e048);

long Times_67b919994d5b486ea006665ee4804fbd[3];
times(Add_2fbd653b6690489ca6a2082e6c456d7f, PhaseTriangle_2aad8df0b1fd473480b73be3d544e048, Times_67b919994d5b486ea006665ee4804fbd);

long AddModulo_faf731f098a4407ea34adfb3f6f77a4e[3];
add_modulo(LFOTriangle_7c044b8a1c7e425a82ca76a053a0f909, Times_67b919994d5b486ea006665ee4804fbd, AddModulo_faf731f098a4407ea34adfb3f6f77a4e);

long Minus_61d42deff1ec4df0aef06c8b051f7794[3];
minus(Const_f794688614f14b11856e272da8292b19, AddModulo_faf731f098a4407ea34adfb3f6f77a4e, Minus_61d42deff1ec4df0aef06c8b051f7794);

long *CreateRef_d1c6e46b00f448ec9964a765047a2dfc = Minus_61d42deff1ec4df0aef06c8b051f7794;

long Const_e81b0888ebee4826b54e00617fc40b95[3] = {4095,4095,4095};

long *Ref_6417a5ace72b488d97095b9c83bc857f = CreateRef_d1c6e46b00f448ec9964a765047a2dfc;

long Times_0374f32e9415463a8000c21f4dbed8d2[3];
times(Const_e81b0888ebee4826b54e00617fc40b95, Ref_6417a5ace72b488d97095b9c83bc857f, Times_0374f32e9415463a8000c21f4dbed8d2);

long Const_311c4574b7774297930aab8dc1393c56[3] = {4000,6842,7712};

long LFOTriangle_dc46f01fa1f440f2a9985879a5d651e9[3];
lfo_triangle(mils, Const_311c4574b7774297930aab8dc1393c56, LFOTriangle_dc46f01fa1f440f2a9985879a5d651e9);

long LampPhase_2c3fcc26fd054330a6a4dcbb4ebaa63e[3] = {this_phase, this_phase, this_phase};

long AddModulo_9a1f28c528a144858ed3bb472f777242[3];
add_modulo(LFOTriangle_dc46f01fa1f440f2a9985879a5d651e9, LampPhase_2c3fcc26fd054330a6a4dcbb4ebaa63e, AddModulo_9a1f28c528a144858ed3bb472f777242);

long Times_a87e9f9c96894a13ab79935a1ce04205[3];
times(Times_0374f32e9415463a8000c21f4dbed8d2, AddModulo_9a1f28c528a144858ed3bb472f777242, Times_a87e9f9c96894a13ab79935a1ce04205);

long Gamma_0f79cdbc25d143ca92005ab1b74d40e3[3];
gamma(Times_a87e9f9c96894a13ab79935a1ce04205, Gamma_0f79cdbc25d143ca92005ab1b74d40e3);

// output
strip.setPixelColor(i, (byte)long_mult(255, Gamma_0f79cdbc25d143ca92005ab1b74d40e3[0]), (byte)long_mult(255, Gamma_0f79cdbc25d143ca92005ab1b74d40e3[1]), (byte)long_mult(255, Gamma_0f79cdbc25d143ca92005ab1b74d40e3[2]));

// end of generated code
  }
  strip.show();
}

void add(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] + op2[0];
  out[1] = op1[1] + op2[1];
  out[2] = op1[2] + op2[2];
}

void add_constrain(long op1[3], long op2[3], long out[3]) {
  out[0] = constrain(op1[0] + op2[0], 0, INTEGER_SCALE);
  out[1] = constrain(op1[1] + op2[1], 0, INTEGER_SCALE);
  out[2] = constrain(op1[2] + op2[2], 0, INTEGER_SCALE);
}

void add_modulo(long op1[3], long op2[3], long out[3]) {
  out[0] = (op1[0] + op2[0]) % INTEGER_SCALE;
  out[1] = (op1[1] + op2[1]) % INTEGER_SCALE;
  out[2] = (op1[2] + op2[2]) % INTEGER_SCALE;
}

void divide(long numerator[3], long denominator[3], long out[3]) {
  out[0] = long_div(numerator[0], denominator[0]);
  out[1] = long_div(numerator[1], denominator[1]);
  out[2] = long_div(numerator[2], denominator[2]);
}

long neopix_gamma[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 18, 20, 22, 24, 26, 28, 31, 33, 36, 39, 42, 45, 48, 51, 55, 59, 62, 66, 71, 75, 79, 84, 89, 94, 99, 104, 110, 116, 122, 128, 134, 140, 147, 154, 161, 168, 176, 184, 192, 200, 208, 217, 225, 234, 244, 253, 263, 273, 283, 293, 304, 315, 326, 338, 349, 361, 373, 386, 398, 411, 425, 438, 452, 466, 480, 495, 510, 525, 541, 556, 572, 589, 605, 622, 640, 657, 675, 693, 712, 730, 750, 769, 789, 809, 829, 850, 871, 892, 914, 936, 959, 981, 1004, 1028, 1052, 1076, 1100, 1125, 1150, 1176, 1202, 1228, 1255, 1282, 1309, 1337, 1365, 1393, 1422, 1452, 1481, 1511, 1542, 1572, 1604, 1635, 1667, 1700, 1733, 1766, 1799, 1833, 1868, 1903, 1938, 1974, 2010, 2046, 2083, 2121, 2158, 2197, 2235, 2274, 2314, 2354, 2394, 2435, 2476, 2518, 2560, 2603, 2646, 2690, 2734, 2778, 2823, 2869, 2915, 2961, 3008, 3055, 3103, 3151, 3200, 3249, 3299, 3349, 3399, 3451, 3502, 3554, 3607, 3660, 3714, 3768, 3823, 3878, 3933, 3990, 4046, 4103, 4161, 4219, 4278, 4337, 4397, 4458, 4518, 4580, 4642, 4704, 4767, 4831, 4895, 4959, 5025, 5090, 5157, 5223, 5291, 5359, 5427, 5496, 5566, 5636, 5707, 5778, 5850, 5922, 5995, 6069, 6143, 6218, 6293, 6369, 6446, 6523, 6601, 6679, 6758, 6837, 6917, 6998, 7079, 7161, 7244, 7327, 7410, 7495, 7580, 7665, 7751, 7838, 7926, 8014, 8102};
  
long INTEGER_SCALE_MINUS_ONE = INTEGER_SCALE - 1;
void gamma(long input[3], long out[3]) {
  out[0] = neopix_gamma[map(input[0], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
  out[1] = neopix_gamma[map(input[1], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
  out[2] = neopix_gamma[map(input[2], 0, INTEGER_SCALE_MINUS_ONE, 0, 255) ];
}

void greater_than(long left[3], long right[3], long out[3]) {
  if(left[0] > right[0]) { out[0] = INTEGER_SCALE; } else { out[0] = 0; }
  if(left[1] > right[1]) { out[1] = INTEGER_SCALE; } else { out[1] = 0; }
  if(left[2] > right[2]) { out[2] = INTEGER_SCALE; } else { out[2] = 0; }
}

void greater_than_equals(long left[3], long right[3], long out[3]) {
  if(left[0] >= right[0]) { out[0] = INTEGER_SCALE; } else { out[0] = 0; }
  if(left[1] >= right[1]) { out[1] = INTEGER_SCALE; } else { out[1] = 0; }
  if(left[2] >= right[2]) { out[2] = INTEGER_SCALE; } else { out[2] = 0; }
}

void less_than(long left[3], long right[3], long out[3]) {
  if(left[0] > right[0]) { out[0] = INTEGER_SCALE; } else { out[0] = 0; }
  if(left[1] > right[1]) { out[1] = INTEGER_SCALE; } else { out[1] = 0; }
  if(left[2] > right[2]) { out[2] = INTEGER_SCALE; } else { out[2] = 0; }
}

void less_than_equals(long left[3], long right[3], long out[3]) {
  if(left[0] >= right[0]) { out[0] = INTEGER_SCALE; } else { out[0] = 0; }
  if(left[1] >= right[1]) { out[1] = INTEGER_SCALE; } else { out[1] = 0; }
  if(left[2] >= right[2]) { out[2] = INTEGER_SCALE; } else { out[2] = 0; }
}

long half_int_scale_vec[3] = {long(INTEGER_SCALE / 2), long(INTEGER_SCALE / 2), long(INTEGER_SCALE / 2)};
void lfo_square(long mils, long cycle_ms[3], long out[3]) {
  long phase[3];
  phasor(mils, cycle_ms, phase);
  greater_than(phase, half_int_scale_vec, out);
}

long twice_int_scale_vec[3] = {long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2)};
void lfo_triangle(long mils, long cycle_ms[3], long out[3]) {
  long phase[3];
  phasor(mils, cycle_ms, phase);
  long times_result[3];
  times(phase, twice_int_scale_vec, times_result);
  if(times_result[0] > INTEGER_SCALE) { out[0] = (twice_int_scale_vec[0] - times_result[0]); } else { out[0] = times_result[0]; }
  if(times_result[1] > INTEGER_SCALE) { out[1] = (twice_int_scale_vec[1] - times_result[1]); } else { out[1] = times_result[1]; }
  if(times_result[2] > INTEGER_SCALE) { out[2] = (twice_int_scale_vec[2] - times_result[2]); } else { out[2] = times_result[2]; }
}

//void lookup(long index[3], long table[][3], long table_size, long out[3]) {
//  out[0] = table[long_mult(index[0], table_size)];
//  out[1] = table[long_mult(index[1], table_size)];
//  out[2] = table[long_mult(index[2], table_size)];
//}

void maximum(long op1[3], long op2[3], long out[3]) {
  out[0] = max(op1[0], op2[0]);
  out[1] = max(op1[1], op2[1]);
  out[2] = max(op1[2], op2[2]);
}

void minimum(long op1[3], long op2[3], long out[3]) {
  out[0] = min(op1[0], op2[0]);
  out[1] = min(op1[1], op2[1]);
  out[2] = min(op1[2], op2[2]);
}

void minus(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] - op2[0];
  out[1] = op1[1] - op2[1];
  out[2] = op1[2] - op2[2];
}

void modulo(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] % op2[0];
  out[1] = op1[1] % op2[1];
  out[2] = op1[2] % op2[2];
}

void noise(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = random(INTEGER_SCALE);
  out[2] = random(INTEGER_SCALE);
}

void noise_pixel(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = out[0];
  out[2] = out[1];
}

void phasor(long mils, long cycle[3], long out[3]) {
  out[0] = long_div((mils % cycle[0]), cycle[0]);
  out[1] = long_div((mils % cycle[1]), cycle[1]);
  out[2] = long_div((mils % cycle[2]), cycle[2]);
}

void times(long op1[3], long op2[3], long out[3]) {
  out[0] = long_mult(op1[0], op2[0]);
  out[1] = long_mult(op1[1], op2[1]);
  out[2] = long_mult(op1[2], op2[2]);
}

//long twice_int_scale_vec[3] = {long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2)};
void triangle(long mils, long phase[3], long out[3]) {
  long times_result[3];
  times(phase, twice_int_scale_vec, times_result);
  if(times_result[0] > INTEGER_SCALE) { out[0] = (twice_int_scale_vec[0] - times_result[0]); } else { out[0] = times_result[0]; }
  if(times_result[1] > INTEGER_SCALE) { out[1] = (twice_int_scale_vec[1] - times_result[1]); } else { out[1] = times_result[1]; }
  if(times_result[2] > INTEGER_SCALE) { out[2] = (twice_int_scale_vec[2] - times_result[2]); } else { out[2] = times_result[2]; }
}

void maxfunction(long op1[3], long op2[3], long out[3]) {
  out[0] = max(op1[0], op2[0]);
  out[1] = max(op1[1], op2[1]);
  out[2] = max(op1[2], op2[2]);
}

