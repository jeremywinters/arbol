class AnalogPin < Base
  Arbol.add_mapped_class(
    'analog_pin',
    AnalogPin,
%{void analog_pin(
  int pin,
  byte scale,
  long in_lo,
  long in_hi,
  long out_lo,
  long out_hi,
  long threshold,
  long window[],
  long& running_total,
  int& current_index,
  long window_size,
  long feedback,
  long& storage,
  long out[3]) {
  long reading = long_mult(long_div(analogRead(pin), 4095), INTEGER_SCALE);

  // scaling
  if(scale == 1) {
    reading = constrain(
      map(
        reading,
        in_lo,
        in_hi,
        out_lo,
        out_hi
      ),
      out_lo,
      out_hi
    );
  }

  // apply a threshold
  if(threshold >= 0) {
    if(reading >= threshold) {
      reading = INTEGER_SCALE;
    }
    else {
      reading = 0;
    }
  }

  // averaging
  if(window_size > 1) {
    // remove the element at current_index from the running total
    running_total -= window[current_index];

    // store reading to current index for deletion in a later frame
    window[current_index] = reading;

    // add current reading to running total
    running_total += window[current_index];
    
    // calculate the average
    reading = long(float(running_total) / (float(INTEGER_SCALE) * window_size) * INTEGER_SCALE);
    
    // increment current_index
    current_index += 1;

    //set it to zero if we reached window_size
    if(current_index == window_size) { current_index = 0; }
  }

  if(feedback > 0) {
    reading = max(reading, storage);
    storage = constrain(long_mult(reading, feedback), 0, INTEGER_SCALE);
  }

  out[0] = reading;
  out[1] = reading;
  out[2] = reading;
}}
  )

  def initialize(params)
    @frame_optimized = true
    @name = "#{self.class}_#{SecureRandom.uuid.to_s.gsub('-','')}"
    @pin = params[:pin]
    
    @scale = params[:scale]
    @in_lo = params[:in_lo]
    @in_hi = params[:in_hi]
    @out_lo = params[:out_lo]
    @out_hi = params[:out_hi]
    
    @threshold = params[:threshold]
    @window = params[:window]
    @feedback = params[:feedback]
    # buildit
  end

  def depends_on
    []
  end

  attr_accessor :pin
  
  attr_accessor :scale
  attr_accessor :in_lo
  attr_accessor :in_hi
  attr_accessor :out_lo
  attr_accessor :out_hi
  
  attr_accessor :threshold
  attr_accessor :window
  attr_accessor :feedback

  def arduino_code
    unless @frame_optimized 
    [
%{analog_pin(
  #{@pin},
  #{@name}_scale,
  #{@name}_in_lo,
  #{@name}_in_hi,
  #{@name}_out_lo,
  #{@name}_out_hi,
  #{@name}_threshold,
  #{@name}_window,
  #{@name}_running_total,
  #{@name}_current_index,
  #{seconds_to_frames(@window)},
  #{@name}_feedback,
  #{@name}_storage,
  #{@name});}
    ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
    [
%{analog_pin(
  #{@pin},
  #{@name}_scale,
  #{@name}_in_lo,
  #{@name}_in_hi,
  #{@name}_out_lo,
  #{@name}_out_hi,
  #{@name}_threshold,
  #{@name}_window,
  #{@name}_running_total,
  #{@name}_current_index,
  #{seconds_to_frames(@window)},
  #{@name}_feedback,
  #{@name}_storage,
  #{@name});}
    ]
    else
      []
    end
  end
  
  def top_level_scope_code
    [
      "// pinMode(#{@pin}, INPUT);",
      "long #{@name}[3];",
      
      "byte #{@name}_scale = #{@scale};",
      "long #{@name}_in_lo = #{@in_lo};",
      "long #{@name}_in_hi = #{@in_hi};",
      "long #{@name}_out_lo = #{@out_lo};",
      "long #{@name}_out_hi = #{@out_hi};",

      "long #{@name}_threshold = #{@threshold};",

      "long #{@name}_window[#{seconds_to_frames(@window)}];",
      "long #{@name}_running_total;",
      "int #{@name}_current_index;",

      "long #{@name}_feedback = #{@feedback};",
      "long #{@name}_storage;"
    ]
  end

  def seconds_to_frames(seconds)
    (seconds * 30.0).to_i
  end
end

module Arbol
  class Documentation

  def analog_pin
%{--
### analog\\_pin(pin, in\\_lo, in\\_hi, out\\_lo, out\\_hi, threshold, window, feedback)

* **pin** - arduino pin to use as input.. either a number or A0, A1, etc...
* **in\\_lo** - scale and constrain.. lo value for input range
* **in\\_hi** - scale and constrain.. hi value for input range
* **out\\_lo** - scale and constrain.. lo value for output range
* **out\\_hi** - scale and constrain.. hi value for output range
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
}
  end

  end
end

def analog_pin(
    pin:,
    in_lo: 0,
    in_hi: 1.0,
    out_lo: 0,
    out_hi: 1.0,
    threshold: nil,
    window: nil,
    feedback: nil
  )
  
  h = ArbolHash.new
  h[:type] = 'analog_pin'
  h[:pin] = resolve_pin_reference(pin)

  # set scaling if any of the scale parameters are changed
  h[:scale] = 0
  h[:scale] = 1 if in_lo != 0
  h[:scale] = 1 if in_hi != 1.0
  h[:scale] = 1 if out_lo != 0
  h[:scale] = 1 if out_hi != 1.0

  h[:in_lo] = resolve_positive_scalar(in_lo)
  h[:in_hi] = resolve_positive_scalar(in_hi)
  h[:out_lo] = resolve_positive_scalar(out_lo)
  h[:out_hi] = resolve_positive_scalar(out_hi)
  
  if threshold
    h[:threshold] = resolve_positive_scalar(threshold)
  else
    h[:threshold] = -1
  end
  
  if window
    h[:window] = resolve_float(window)
  else
    h[:window] = 0.0
  end
  
  if feedback
    h[:feedback] = resolve_positive_scalar(feedback)
  else
    h[:feedback] = 0
  end
  puts(h)
  h
end

=begin
steps:

1. read pin

pin

2. optionally map/constrain

scale
in_low
in_hi
out_low
out_hi


3. optional threshold

threshold

4. optional averaging window

window

5. optional feedback

feedback

=end