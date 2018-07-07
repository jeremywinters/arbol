--
### add(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2. can also be used in the form `op1 + op2`.

--
### add_constrain(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2, then constrains the result between 0.0-~1.0.

--
### add_modulo(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2, then returns the result modulo 1.0.

--
### analog\_pin(pin, in\_lo, in\_hi, out\_lo, out\_hi, threshold, window, feedback)

* **pin** - arduino pin to use as input.. either a number or A0, A1, etc...
* **in\_lo** - scale and constrain.. lo value for input range
* **in\_hi** - scale and constrain.. hi value for input range
* **out\_lo** - scale and constrain.. lo value for output range
* **out\_hi** - scale and constrain.. hi value for output range
* **threshold** - edge detection.. outputs INTEGER_SCALE if >= threshold.. otherwise zero
* **window** - input will be averaged by frame across this many seconds
* **feedback** - feeback amount applied to the input

Once per frame the specified pin is sampled, then the data is run through a chain of optional processing to add usefulness to signals that can be noisy, incorrectly offset, or too fast or squirrely. 

The chain of processing is as follows:

* Pin is sampled once per frame.
* Scale and Constrain - Sampled value is scaled and constrained to the values specified by `in_lo`, `in_hi`, `out_lo`, `out_hi`. This functionality is enabled by specifying any one of these parameters, which default to 0.0, 1.0, 0.0, and 1.0 respectively. 
* Edge detection - If `threshold` is specified, the value outputs 1.0 if >= `threshold` and 0.0 otherwise.
* Averaging window - Specifying a `window` value (in seconds, as a float) allows for the input to be averaged across the time period. The averages are calculated using a buffer that stores 30 frames for each second specified. Averaging provides a less jerky, slower control signal.
* Feedback - Specifying `feedback` (float between 0-1) applies a simple feedback calculation. This creates a longer "tail" on the control signal.

The above processes are calculated in the order specified above, with each stage feeding into the next.. unless the process is disabled, meaning that no parameter value is specified to enable it.

`analog_pin` uses named parameters as shown in the various examples below.

```
sensor = analog_pin(
  pin: 'A1'
);

sensor = analog_pin(
  pin: 'A1',
  in_lo: 0.1,
  threshold: 0.4
);

sensor = analog_pint(
  pin: 'A1',
  window: 0.5,
  feedback: 0.95
);
```
--
### choose(choice, op1, op2)

* **choice** - selects the operator to be returned
* **op1** - operator1
* **op2** - operator2

Returns operator1 if choice < 0.5.. or operator2 if choice >= 0.5.

--
### const(value)

* **value** - input value to be used as a constant.

You can specify a constant explicity:

```
const(0.4)

or

const([0.1, 0.2, 0.3])
```

..but generally you specify constants directly as values. There is no advantage in using the function.


```
0.4

or

[0.1, 0.2, 0.3]
```
--
### crossfade(fader, channel1, channel2)

* **fader** - fade amount between channels
* **channel1** - channel1
* **channel2** - channel2

Returns a mix of channels 1 and 2 based on the fader amount between 0-~1.0.

--
### divide(numerator, denominator)

* **numerator**
* **denominator**

Division. Also accepts the form `numerator / denominator`.

--
### feedback(input, feedback)

* **input**
* **feedback**

Returns the greatest of the input or the feedback value.

--
### feedback_offset(input, feedback, offset)

* **input**
* **feedback**
* **offset**

Returns the greatest of the input or the feedback value at the offset (0-~1.0) 
from the current pixel.

--
### gamma(input)

* **input**

Returns gamma corrected input. This makes the colors look much better.

--
### greater_than(left, right)

* **left** - left operand
* **right** - right operand

left > right as a logical operation returning 0 or 1.0.
Can be used in the form `left > right`.

--
### greater\_than\_equals(left, right)

* **left** - left operand
* **right** - right operand

left >= right as a logical operation returning 0 or 1.0.
Can be used in the form `left >= right`.

--
### lamp_phase

Returns current lamp number expressed as a phase 0-~1.0.

--
### less\_than(left, right)

* **left** - left operand
* **right** - right operand

left < right as a logical operation returning 0 or 1.0.
Can be used in the form `left < right`.

--
### less\_than\_equals(left, right)

* **left** - left operand
* **right** - right operand

left <= right as a logical operation returning 0 or 1.0.
Can be used in the form `left <= right`.

--
### lfo\_square(cycle\_ms)

* **cycle\_ms** - cycle length expressed as milliseconds

Outputs a square wave. Note that the cycle length value is interpreted literally
as milliseconds, so you should use integer constants as input.

--
### lfo\_triangle(cycle\_ms)

* **cycle\_ms** - cycle length expressed as milliseconds

Outputs a triangle wave. Note that the cycle length value is interpreted literally
as milliseconds, so you should use integer constants as input.

--
### lookup(table\_reference, index)

* **table\_reference** - reference to a predefined table.
* **index** - index used to look up the value in the table.

Allows you to lookup values in a user defined table. Note that the table must be declared before it is referenced.

```
my_table = [0, 0.5, 0.6, 0.0, 0.9];

my_lookup = lookup(
  my_table,
  phasor(1000)
);
```
--
### max(left, right)

* **operator1**
* **operator2**

Maximum (greater) of the two operators.

--
### min(left, right)

* **operator1**
* **operator2**

Minimum (least) of the two operators.

--
### minus(operator1, operator2)

* **operator1**
* **operator2**

Difference of the two operators. Can also be used with the form `operator1 - operator2`.

--
### mod(operator1, operator2)

* **operator1**
* **operator2**

Modulo of the two operators. Can also be used with the form `operator1 % operator2`.

--
### noise

Outputs a random value for RGB of each pixel.

--
### noise\_pixel

Outputs a random value for each pixel.

--
### phasor(cycle_ms)

* **cycle_ms**

Outputs a ramp wave from 0-~1.0 over a period of cycle_ms milliseconds.

`phasor` is very important because it highlights a key way to bring motion into
the system. There are many ways of using phasor.

```
# go from 0-~1.0 over a period of 10 seconds:
phasor(10000)

# each of the three channels goes from 0-~1.0 at different millisecond intervals:
phasor([1000, 1100, 1200])

# phasor is input into a triangle function, which then creates a triangle
# wave that goes from 0-~1.0-0 over a period of 5 seconds specified
# to the phasor
tri = triangle(phasor(5000))

# multiple two triangles together to to get a pointy triangle
tri_squared = tri * tri

# using `lamp_phase` function in conjunction with `add_constrain` you can
# create motion in the lamps.

strip(
  512, # 512 pixels
  0,   # attached to pin 0
  add_constrain(
    lamp_phase,
    phasor([1000, 1200, 1300])  
  )
```

--
### scale needs doc

--
### times(operator1, operator2)

* **operator1**
* **operator2**

Multiplication of the two operators. Can also be used with the form `operator1 * operator2`.

--
### triangle(phase)

* **phase**

`phase` input 0.0-1.0 input is transformed into a triangle.

