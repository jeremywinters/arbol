# Arbol

This project started out as a way to make programming lights on the arduino more accessible to novices. Somehow... it turned into a declarative, functional metalanguage.

Arbol is inspired by concepts such as DSP chains and modular synthesizers, but instead of processing audio signals, arbol processes 3 channel RGB streams which are displayed on neopixel chains.

This software is extremely experimental, and makes use of metaprogramming constructs such as `eval`. Think about that before running it in a rails app from your production cluster.

## Install

Arbol installs as an executable by way of a ruby gem:

```
gem build arbol.gemspec
gem install arbol-0.0.1.gem
```

## Usage

Arbol is a transpiler that converts arbol code into scripts designed to run in Arudino microcontrollers... which are basically c/c++.

Put your arbol code in a file... then pass the file name to the arbol command line executable. The files can be in one of two formats, JSON, or the arbol format... which is a hacked up version of ruby. The second path is the name of the arduino script file you want to create/overwrite. 

Try the example included in the repo.

```
$ arbol example.rb example.ino
```

Later versions of the Arduino IDE have a command line tool that you can use for compiling and loading sketches. I add the following to my `~/.bash_profile`:

```
alias arduino="/Applications/Arduino.app/Contents/MacOS/Arduino"
```

...which allows me to transpile the arbol file into an arduino sketch file (.ino) then write the sketch directly into the arduino without using the GUI based IDE:

```
$ arbol example.rb example.ino ; arduino --upload --board arduino:samd:mzero_bl --port /dev/cu.usbmodem1421 example.ino.ino
```

## Language

Arbol is a declarative, functional language. Technically, the syntax is a ruby DSL, but it shouldn't be treated as, or mixed with other ruby.

Arbol allows you to define a function chain which gets applied to strip of LEDs. The functions are driven by 3 primary types of input:

* `mils` - milliseconds that the arduino has been running. `mils` is not a value you use directly, it is used (under the covers) to calculate time based functions (such as `phasor`).
* `lamp_phase` - value between 0-1 indicating which lamp in the strip is being calculated, 0 being the first lamp, and 1 being the last, and all the other lamps in-between.
* constants - hard coded numbers passed to functions.

Let's talk more about constants.. and numbers in general!

### Numbers and Constants

#### Integer scale and floats

All of the math inside the arbol arduino script is performed with long integers, meaning that floating point (float) numbers are not directly supported. Floating point math in an arduino requires a lot of processing power and memory. Instead of using floats, arbol uses integer math based on a predefined scale. 0.0-1.0 are represented inside the arduino as 0-8192.

Below is a simple arbol expression:

```
a = 8192 * 8192;
```

...which is basically like saying "a equals 1 times 1". This integer conversion can be a bit painful... so arbol also supports entering numbers as floats (with a decimal point), which will get converted to the appropriate integer value in the arduino script.

The example below is equivalent to the one above:

```
a = 1.0 * 1.0;
```

Keep in mind that float values will be truncated to the nearest integer... so don't expect incredibly high granularity when entering in float values.

In most cases, you will want to specify float values because in future releases of arbol we intend to support changing the integer scale, adding or removing granularity depending upon the use case.

#### Constants

In the following expression:

```
a = 1.0 * 1.0;
```

...both occurances of `1.0	` are constant values, that will never change throughout the program. 

Constants can also be declared as arrays of 3 numbers:

```
a = [1.0, 1.0, 1.0] * 1.0;
```

What may be strange for you to hear is that the above expression is also equivalent to the other two examples given above! How can this be???

#### Always three numbers

Every function in arbol returns an array of 3 long integers. Each of these "channels" corresponds to the red, green, and blue lamps in each pixel LED. 

If you define a constant with a single value, that value will be converted to an array with the value repeated 3 times. If you specify an array as a constant, all three of the numbers can vary. This kind of thing becomes fun when you are using object such as `phasor` which essentially creates a ramp wave from 0.0-~1.0, repeating at the time interval specified in milliseconds.

```
ramp = phasor([1000, 1500, 1800]);
```

In the example above, the phasor will output 3 asynchronous ramp functions, with periods of 1 second, 1.5 seconds, and 1.8 seconds.

A few notes here:

1. Any parameter expecting milliseconds should be provided in integer format.
2. This is something we intend to think through a bit more clearly in an upcoming version of arbol.


### Expressions

Arbol programs all reduce down to a single tree of functions. To make your code modular, you can assign a subtree to a variable name:

```
ramp = phasor([1000, 1500, 1800]);
```

In this case, the phasor function is assigned to the name `ramp`. Now that ramp is declared, we can use it in the next subtree:

```
ramp_squared = ramp * ramp;
```

Inside the arduino, `ramp` is only calculated once per pixel per frame, then reused when calculating `ramp_squared`. This is a simple but important optimization.

Below is an example where `ramp` is cubed!

```
ramp = phasor([1000, 1500, 1800]);
ramp_cubed = ramp * ramp * ramp;
```

If you are going to reuse values in your tree, it is important to assign them to names.

### Strips

The last declaration in your arbol program needs to be a `strip`. Below is the entire program:

```
strip(
  100, # number of lamps in strip
  1,   # arduino pin that the strip is connected to
  1.0  # indicates full brightness for every light
);
```

The strip will be configured to have 100 lamps on pin 1 when the arduino starts up.

After setup, for every frame, the value of each lamp will be calculated. The only input to the strip in our program is the number `1.0`. If a single number is provided as a constant value, it will apply to all three of the RGB channels. In this case we're saying that the RGB value of every lamp should be set to `1.0` which translates to full brightness.

NOTE: Powering pixel strands is a deeper topic. I bring it up here for safety consideration because turning on 100 lamps to full brightness requires a fair amount of power. Be sure to consider your maximum power draw. Look to the Adafruit site for more information: [https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels]()

Here's a few other simple examples:

```
strip(
  100,                 # number of lamps in strip
  1,                   # arduino pin that the strip is connected to
  [1.0, 0.125, 0.125]  # R is full bright and 8x brighter than G or B for every lamp
);
```

```
strip(
  100,                 # number of lamps in strip
  1,                   # arduino pin that the strip is connected to
  [1.0, 0.0, 0.0] * phasor(10000);
);
```

The above example calculates a `phasor` with a period of 10000ms per cycle. The `phasor` will gradually increase from 0 to 1 every 10 seconds.

The output of the `phasor` is multiplied by the constant array provided. The array is applied to RGB respectively, which results in all R values passing through, while G and B are masked, or muted with multiplication by `0.0`. The visual result will be a red glow that gets brighter over a period of 10 seconds before starting over again.

Check out FUNCTIONS.md for a list of all operators and function definitions.

## Future

Ideas on the roadmap:

* Create a web based UI using [blockly](https://developers.google.com/blockly/).
* Table based lookup functions (coming soon!)
* Reusable function declarations.
* Ability to memoize a phase driven function chain for specified granularity of steps between 0-~1.0.
* Input from arduino pins.
* Midi input/output.
* Function tree optimizer.