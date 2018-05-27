$lookup_tables = {}

class LookupTable < Base
  Arbol.add_mapped_class(
    'table', 
    LookupTable,
    %{}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:index, :table]
  end
  
  def arduino_code
    [
      "lookup(#{@index.name},  #{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

def resolve_lookup(val)
  raise "table definition must be an array" unless val.class == Array
  val.map do |v|
    case
      when val.class == Fixnum then (1..3).map { scale_correctly(val) }
      when val.class == Float then (1..3).map { scale_correctly(val) }
      when val.class == Array then v.map { |i| scale_correctly(i) }
    end
  end
end

def lookup(table, index)
  {
    type: 'lookup',
    table: resolve_lookup(table),
    index: resolve(index)
  }
end