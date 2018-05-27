$tables = {}

class CreateTable < Base
  Arbol.add_mapped_class(
    'table', 
    CreateTable, 
    nil
  )
  
  attr_accessor :identifier
  attr_accessor :value
  
  def initialize(params)
    super(params)
    @identifier = params[:identifier]
    unless $tables.has_key?(@identifier)
      $tables[@identifier] = @value
    else
      raise "duplicate table definition #{params[:name]}"
    end
  end

  def param_keys
    [:value]
  end
  
  def arduino_code
    []
  end

  def top_level_scope_code
    [
      "long *#{@name} = #{@value.name};"
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

def create_table_ref(identifier, value)
  h = ArbolHash.new
  h[:type] = 'table'
  h[:identifier] = identifier
  h[:value] = resolve_lookup(value)
  h
end