require 'securerandom'
require 'tsort'

class TsortableHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class ArbolHash < Hash
  def +(y)
    h = ArbolHash.new
    h[:type] = 'add'
    h[:op1] = self.to_h
    h[:op2] = resolve(y)
    h
  end

  def -(y)
    h = ArbolHash.new
    h[:type] = 'minus'
    h[:op1] = self.to_h
    h[:op2] = resolve(y)
    h
  end
  
  def *(y)
    h = ArbolHash.new
    h[:type] = 'times'
    h[:op1] = self.to_h
    h[:op2] = resolve(y)
    h
  end

  def /(y)
    h = ArbolHash.new
    h[:type] = 'divide'
    h[:op1] = self.to_h
    h[:op2] = resolve(y)
    h
  end

  def %(y)
    h = ArbolHash.new
    h[:type] = 'modulo'
    h[:op1] = self.to_h
    h[:op2] = resolve(y)
    h
  end
  
  def >(y)
    h = ArbolHash.new
    h[:type] = 'greater_than'
    h[:left] = self.to_h
    h[:right] = resolve(y)
    h
  end
  
  def >=(y)
    h = ArbolHash.new
    h[:type] = 'greater_than_equals'
    h[:left] = self.to_h
    h[:right] = resolve(y)
    h
  end

  def <(y)
    h = ArbolHash.new
    h[:type] = 'less_than'
    h[:left] = self.to_h
    h[:right] = resolve(y)
    h
  end
  
  def <=(y)
    h = ArbolHash.new
    h[:type] = 'less_than_equals'
    h[:left] = self.to_h
    h[:right] = resolve(y)
    h
  end 
end

module RefineBasics
  refine Integer do
    def +(y)
      h = ArbolHash.new
      h[:type] = 'add'
      h[:op1] = resolve(self.to_i)
      h[:op2] = resolve(y)
      h
    end
  
    def -(y)
      h = ArbolHash.new
      h[:type] = 'minus'
      h[:op1] = resolve(self.to_i)
      h[:op2] = resolve(y)
      h
    end
    
    def *(y)
      h = ArbolHash.new
      h[:type] = 'times'
      h[:op1] = resolve(self.to_i)
      h[:op2] = resolve(y)
      h
    end
  
    def /(y)
      h = ArbolHash.new
      h[:type] = 'divide'
      h[:op1] = resolve(self.to_i)
      h[:op2] = resolve(y)
      h
    end
  
    def %(y)
      h = ArbolHash.new
      h[:type] = 'modulo'
      h[:op1] = resolve(self.to_i)
      h[:op2] = resolve(y)
      h
    end

    def >(y)
      h = ArbolHash.new
      h[:type] = 'greater_than'
      h[:left] = self.to_i
      h[:right] = resolve(y)
      h
    end
    
    def >=(y)
      h = ArbolHash.new
      h[:type] = 'greater_than_equals'
      h[:left] = self.to_i
      h[:right] = resolve(y)
      h
    end
  
    def <(y)
      h = ArbolHash.new
      h[:type] = 'less_than'
      h[:left] = self.to_i
      h[:right] = resolve(y)
      h
    end
    
    def <=(y)
      h = ArbolHash.new
      h[:type] = 'less_than_equals'
      h[:left] = self.to_i
      h[:right] = resolve(y)
      h
    end 
  end

  refine Float do
    def +(y)
      h = ArbolHash.new
      h[:type] = 'add'
      h[:op1] = resolve(self.to_f)
      h[:op2] = resolve(y)
      h
    end
  
    def -(y)
      h = ArbolHash.new
      h[:type] = 'minus'
      h[:op1] = resolve(self.to_f)
      h[:op2] = resolve(y)
      h
    end
    
    def *(y)
      h = ArbolHash.new
      h[:type] = 'times'
      h[:op1] = resolve(self.to_f)
      h[:op2] = resolve(y)
      h
    end
  
    def /(y)
      h = ArbolHash.new
      h[:type] = 'divide'
      h[:op1] = resolve(self.to_f)
      h[:op2] = resolve(y)
      h
    end
  
    def %(y)
      h = ArbolHash.new
      h[:type] = 'modulo'
      h[:op1] = resolve(self.to_f)
      h[:op2] = resolve(y)
      h
    end
  
    def >(y)
      h = ArbolHash.new
      h[:type] = 'greater_than'
      h[:left] = self.to_f
      h[:right] = resolve(y)
      h
    end
    
    def >=(y)
      h = ArbolHash.new
      h[:type] = 'greater_than_equals'
      h[:left] = self.to_f
      h[:right] = resolve(y)
      h
    end
  
    def <(y)
      h = ArbolHash.new
      h[:type] = 'less_than'
      h[:left] = self.to_f
      h[:right] = resolve(y)
      h
    end
    
    def <=(y)
      h = ArbolHash.new
      h[:type] = 'less_than_equals'
      h[:left] = self.to_f
      h[:right] = resolve(y)
      h
    end 
  end

  refine Array do
    def +(y)
      h = ArbolHash.new
      h[:type] = 'add'
      h[:op1] = resolve(self.to_a)
      h[:op2] = resolve(y)
      h
    end
  
    def -(y)
      h = ArbolHash.new
      h[:type] = 'minus'
      h[:op1] = resolve(self.to_a)
      h[:op2] = resolve(y)
      h
    end
    
    def *(y)
      h = ArbolHash.new
      h[:type] = 'times'
      h[:op1] = resolve(self.to_a)
      h[:op2] = resolve(y)
      h
    end
  
    def /(y)
      h = ArbolHash.new
      h[:type] = 'divide'
      h[:op1] = resolve(self.to_a)
      h[:op2] = resolve(y)
      h
    end
  
    def %(y)
      h = ArbolHash.new
      h[:type] = 'modulo'
      h[:op1] = resolve(self.to_a)
      h[:op2] = resolve(y)
      h
    end

    def >(y)
      h = ArbolHash.new
      h[:type] = 'greater_than'
      h[:left] = self.to_a
      h[:right] = resolve(y)
      h
    end
    
    def >=(y)
      h = ArbolHash.new
      h[:type] = 'greater_than_equals'
      h[:left] = self.to_a
      h[:right] = resolve(y)
      h
    end
  
    def <(y)
      h = ArbolHash.new
      h[:type] = 'less_than'
      h[:left] = self.to_a
      h[:right] = resolve(y)
      h
    end
    
    def <=(y)
      h = ArbolHash.new
      h[:type] = 'less_than_equals'
      h[:left] = self.to_a
      h[:right] = resolve(y)
      h
    end 
  end
end

class Base
  attr_accessor :name
  attr_accessor :frame_optimized
  
  def initialize(params)
    @frame_optimized = true # default
    @name = "#{self.class}_#{SecureRandom.uuid.to_s.gsub('-','')}"
    param_keys.each do |k|
      self.send("#{k.to_sym}=", params[k])
    end
    buildit
  end

  def buildit
    param_keys.each do |k|
      # puts "resolving #{k}"
      self.send("#{k.to_sym}=", builder(self.send("#{k.to_s}")))
      # puts "#{k} resolved"
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
    []
  end
  
  def resolve_frame_optimized
    # first resolve the children
    param_keys.each do |k|
      self.send("#{k}").resolve_frame_optimized
    end
    
    # check to see if any of the children can not be optimized
    param_keys.each do |k|
      # if so... mark self as false
      if self.send("#{k}").frame_optimized == false
        @frame_optimized = false
      end
    end
  end
  
  # only executed once per cycle
  def cycle_level_arduino_code
    []
  end
  
  # code to be executed in the top level scope.
  # used for constant declaration
  def top_level_scope_arduino_code
    []
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

  def add_cycle_level_scope(ir)
    ir[@name] = cycle_level_arduino_code
    param_keys.each do |k|
      self.send("#{k}").add_cycle_level_scope(ir)
    end
  end
  
  def add_top_level_scope(ir)
    ir[@name] = top_level_scope_code
    param_keys.each do |k|
      self.send("#{k}").add_top_level_scope(ir)
    end
  end
end