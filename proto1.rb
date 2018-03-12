require 'json'
require 'pp'
require 'securerandom'
require 'tsort'
require 'erb'

class TsortableHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class Base
  attr_accessor :name
  
  def initialize(params)
    @name = "#{self.class}_#{SecureRandom.uuid.to_s.gsub('-','')}"
    param_keys.each do |k|
      self.send("#{k.to_sym}=", params[k.to_s])
    end
    buildit
  end

  def buildit
    param_keys.each do |k|
      self.send("#{k.to_sym}=", builder(self.send("#{k}")))
    end
  end
  
  def param_keys
    []
  end
  
  def depends_on
    return [] if param_keys == []
    param_keys.map { |k| self.send("#{k}").name }
  end
  
  def arduino_code
    nil
  end
  
  def append_tsortable(tsortable)
    tsortable[@name] = depends_on
    param_keys.each do |k|
      self.send("#{k}").append_tsortable(tsortable)
    end
  end
  
  def add_arduino_code(ir)
    ir[@name] = arduino_code
    param_keys.each do |k|
      self.send("#{k}").add_arduino_code(ir)
    end
  end
end

class Times < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def arduino_code
    [
      "unsigned long #{@name}[3];",
      "times(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end
end

class AddModulo < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def arduino_code
    [
      "unsigned long #{@name}[3];",
      "addmodulo(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end
end

class Const < Base
  attr_accessor :value
  
  def initialize(params)
    super
    @value = params['value']
  end

  def arduino_code
    [
      "unsigned long #{@name}[3] = {#{@value.join(',')}};"
    ]
  end
end

class Phasor < Base
  attr_accessor :cycles
  
  def param_keys
    [:cycles]
  end

  def arduino_code
    [
      "unsigned long #{@name}[3];",
      "phasor(mils, #{@cycles.name}, #{@name});"
    ]
  end
end

class LampPhase < Base
  def arduino_code
    [
      "unsigned long #{@name}[3] = {this_phase, this_phase, this_phase};"
    ]
  end
end

def builder(params)
  cl = case params['type']
    when 'times' then Times
    when 'addmodulo' then AddModulo
    when 'const' then Const
    when 'phasor' then Phasor
    when 'lamp_phase' then LampPhase
  end
  cl.new(params)
end

def custom_arduino_script_body(structure)
  # run the builder
  t = builder(
    structure["calc"]
  )
  
  # create a tsortable hash and populate it with the nodes
  ts = TsortableHash.new
  t.append_tsortable(ts)
  
  # creates a hash containing all the code keyed by node name
  code = {}
  t.add_arduino_code(code)
  
  ret = []
  # run tsort... then append the lines of code in the order they should be executed
  t = ts.tsort
  t.each do |func|
    ret << ''
    code[func].each do |stmt|
      ret << stmt
    end
  end
  
  # last output needs to be passed to the strip
  ret << ''
  ret << "// output"
  ret << "strip.setPixelColor(i, neopix_gamma[#{t.last}[0]], neopix_gamma[#{t.last}[1]], neopix_gamma[#{t.last}[2]]);"
  ret
end

# parse the file
tree = JSON.parse(
  File.read(ARGV[0])
)
  
body = custom_arduino_script_body(tree).join("\n")
pixels = tree['lamps']
puts ERB.new(IO.read('arduino_library.ino.erb')).result(binding)


