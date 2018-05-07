require 'json'
require 'pp'
require 'erb'

require_relative 'base.rb'

# module used to handle the global class map
module Irontofu
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
  puts params
  Irontofu.class_map[params[:type]].new(params)
end

def custom_arduino_script_body(structure)
  ref_builders = []
  structure[:refs].each do |ref|
    ref_builders << builder(
      ref
    )
  end

  # run the builder
  t = builder(
    structure[:calc]
  )

  # create a tsortable hash and populate it with the nodes
  ts = TsortableHash.new

  # first append the ref nodes
  ref_builders.each { |r| r.append_tsortable(ts) }

  # then append the primary calc nodes
  t.append_tsortable(ts)

  # creates a hash containing all the code keyed by node name
  code = {}
  
  # creates an array of code for top_level_scope declarations
  top_level_scope = []

  # first append the ref nodes
  ref_builders.each { |r| r.add_arduino_code(code) }

  # then the primary calc nodes
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
  ret << "strip.setPixelColor(i, (byte)long_mult(255, #{t.last}[0]), (byte)long_mult(255, #{t.last}[1]), (byte)long_mult(255, #{t.last}[2]));"
  ret
end

