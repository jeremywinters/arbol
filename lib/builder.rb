require 'json'
require 'pp'
require 'erb'

require_relative 'base.rb'

# module used to handle the global class map
module Arbol
  @@class_map = {}

  def self.class_map
    @@class_map
  end

  def self.add_mapped_class(type, mapped_class, code)
    @@class_map[type] = mapped_class
    @@libs << code if code
  end

  @@libs = []

  def self.libs
    @@libs
  end
end

# new instance of the class specified by params[:type]
def builder(params)
  # puts params
  Arbol.class_map[params[:type]].new(params)
end

def custom_arduino_script_body(structure)
  ref_builders = []
  structure[:refs].each do |ref|
    this_ref = builder(
      ref
    )
    this_ref.resolve_frame_optimized
    ref_builders << this_ref
  end

  # run the builder
  t = builder(
    structure[:calc]
  )
  
  t.resolve_frame_optimized
  
  # create a tsortable hash and populate it with the nodes
  ts = TsortableHash.new

  # first append the ref nodes
  ref_builders.each { |r| r.append_tsortable(ts) }

  # then append the primary calc nodes
  t.append_tsortable(ts)

  # creates a hash containing all the code keyed by node name
  pixel_scope_code = {}
  
  # creates an hash of code for top_level_scope declarations
  top_level_scope_code = {}
  
  # contains cycle level code
  cycle_scope_code = {}

  # first append the ref nodes
  ref_builders.each { |r| r.add_arduino_code(pixel_scope_code) }
  ref_builders.each { |r| r.add_cycle_level_scope(cycle_scope_code) }
  ref_builders.each { |r| r.add_top_level_scope(top_level_scope_code) }
   
  # then the primary calc nodes
  t.add_arduino_code(pixel_scope_code)
  t.add_cycle_level_scope(cycle_scope_code)
  t.add_top_level_scope(top_level_scope_code)

  pixel_scope = []
  top_level_scope = []
  cycle_scope = []
  # run tsort... then append the lines of code in the order they should be executed
  t = ts.tsort
  t.each do |func|
    pixel_scope_code[func].each do |stmt|
      pixel_scope << stmt
    end
    
    cycle_scope_code[func].each do |stmt|
      cycle_scope << stmt
    end
    
    top_level_scope_code[func].each do |stmt|
      top_level_scope << stmt
    end
  end

  # last output needs to be passed to the strip
  pixel_scope << ''
  pixel_scope << "// output"
  pixel_scope << "strip.setPixelColor(i, (byte)long_mult(255, #{t.last}[0]), (byte)long_mult(255, #{t.last}[1]), (byte)long_mult(255, #{t.last}[2]));"
  return top_level_scope, cycle_scope, pixel_scope
end
