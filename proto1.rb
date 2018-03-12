require 'json'
require 'pp'
require 'securerandom'
require 'tsort'

class TsortableHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

tree = JSON.parse(File.read('proto1.json'))

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
  
  def internal_rep
    nil
  end
  
  def append_tsortable(tsortable)
    puts self.class
    tsortable[@name] = depends_on
    param_keys.each do |k|
      self.send("#{k}").append_tsortable(tsortable)
    end
  end
  
  def add_internal_rep(ir)
    ir[@name] = internal_rep
    param_keys.each do |k|
      self.send("#{k}").add_internal_rep(ir)
    end
  end
end

class Times < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def internal_rep
    {
      op1: @op1.name,
      op2: @op2.name
    }
  end
end

class AddModulo < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def internal_rep
    {
      op1: @op1.name,
      op2: @op2.name
    }
  end
end

class Const < Base
  attr_accessor :value
  
  def initialize(params)
    super
    @value = params['value']
  end

  def internal_rep
    {
      value: @value
    }
  end
end

class Phasor < Base
  attr_accessor :cycles
  
  def param_keys
    [:cycles]
  end

  def internal_rep
    {
      op1: @cycles.name
    }
  end
end

class LampPhase < Base
end

def builder(params)
  puts params['type']
  cl = case params['type']
    when 'times' then Times
    when 'addmodulo' then AddModulo
    when 'const' then Const
    when 'phasor' then Phasor
    when 'lamp_phase' then LampPhase
  end
  cl.new(params)
end

t = builder(
  tree["calc"]
)

ts = TsortableHash.new

t.append_tsortable(ts)

ir = {}

t.add_internal_rep(ir)
puts "PARSED TREE"
pp t

puts "TSORT"
pp ts.tsort

puts "IR"
pp ir