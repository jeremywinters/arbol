require 'securerandom'
require 'tsort'

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
      self.send("#{k.to_sym}=", params[k])
    end
    buildit
  end

  def buildit
    param_keys.each do |k|
      puts "resolving #{k}"
      self.send("#{k.to_sym}=", builder(self.send("#{k.to_s}")))
      puts "#{k} resolved"
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
    ''
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

  def function_code
    nil
  end
end