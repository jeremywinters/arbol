require 'json'
require 'pp'
require 'securerandom'

tree = JSON.parse(File.read('proto1.json'))

class Base
  def initialize(params)
    @name = SecureRandom.uuid
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
end

class Times < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
end

class AddModulo < Base
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
end

class Const < Base
  attr_accessor :value
  
  def initialize(params)
    @value = params['value']
  end
end

class Phasor < Base
  attr_accessor :cycles
  
  def param_keys
    [:cycles]
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

pp t