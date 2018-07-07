# scales float values to the integer scale representation.
# @param [Float|Integer] val
# @return [Integer]
def scale_correctly(val)
  case
    when val.class == Integer then return val
    when val.class == Float then return (val * 8192).to_i
  end
end

# resolves an input object to a structure appropriate for the tree.
# @param [Object] val
# @return [Object]
def resolve(val)
  case
    when val.class == Integer then return my_const(scale_correctly(val))
    when val.class == Float then return my_const(scale_correctly(val))
    when val.class == Array then return my_const(
      val.map { |i| scale_correctly(i) }
    )
    when val.class == ArbolHash then return val
  end
end

def resolve_lookup_table(val)
  val.map { |v| resolve(val) }
end

def resolve_integer(val)
  if val.class == Integer
    val
  else
    raise "#{val} is not an integer"
  end
end

def resolve_float(val)
  if val.class == Float
    val
  else
    raise "#{val} is not an float"
  end
end

def resolve_positive_scalar(val)
  if [Integer, Float].include?(val.class)
    if val >= 0
      scale_correctly(val)
    else
      raise "#{} val should be positive"
    end
  else
    raise "#{val} must be a positive scalar number"
  end
end

def resolve_pin_reference(val)
  if val.match(/(^A\d+$|^\d+$)/)
    val
  else
    raise "#{val} is not a valid pin reference"
  end
end

# coerces a scalar value to an array of 3 elements.
# @param [Object] input
# @return [Array]
def coerce_array(input)
  if input.class == Array
    input
  else
    [input, input, input]
  end
end

# top level object to create a neopixel strip
# @param [Integer] lamps
# @param [Integer] pin
# @param [ArbolHash] calc
# @return [Hash]
def strip(lamps, pin, calc)
  {
    type: 'physical_strip',
    lamps: lamps,
    pin: pin,
    calc: resolve(calc)
  }
end

# removes comments from the dsl script
# @param [String] script
# @return [String]
def remove_comments(script)
  t = []
  script.split("\n").each do |line|
    if line.match(/\#/)
      t << line.split('#',2)[0]
    else
      t << line
    end
  end
  t.join("\n")
end

# separates declarations by ; delimiter
# @param [String] script
# @return [Array<String>]
def script_split(script)
  script.split(';').select { |l| l.strip != '' }
end

# converts an array of statements to an arbol tree structure
# @param [Array<String>] stmts
# @param [Binding] scope
# @param [Hash]
def stmts_to_structure(stmts, scope)
  # defined references that can be used in the script
  refs = []
  # injection of ruby code into the eval
  # starts with the refinement, but refs will be added
  refinjects = ['using RefineBasics; ']

  # iterate all of the statements. last statement must be a strip definition
  stmts.each do |stmt|
    # ref handling
    if stmt.match(/(\w|\s)+={1}(\w|\s)+/)
      ref_name = stmt.match(/\w+/)[0]
      statements = "#{refinjects.join('')}#{stmt.split('=', 2)[1]}"
      this_ref = create_ref(
        ref_name,
        eval(statements, scope)
      )
      refinject = "#{ref_name} = ref('#{ref_name}');"
      refs << this_ref
      refinjects << refinject
    # strip handling
    elsif stmt.match('strip')
      statements = "#{refinjects.join('')} #{stmt}"
      retval = eval(statements, scope)
      retval[:refs] = refs
      return retval
    end
  end
end

# converts dsl text to an arbol tree structure
# @param [String] script_text
# @param [Binding] scope
def interpret_dsl(script_text, scope)
  stmts_to_structure(
    script_split(
      remove_comments(
        script_text
      )
    ),
    scope
  )
end

# converts a json string to an arbol tree structure
# @param [String] json_text
# @return [Hash]
def interpret_json(json_text)
  JSON.parse(
    json_text,
    symbolize_names: true
  )
end