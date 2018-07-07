$tables = {}

class CreateLookup < Base
  Arbol.add_mapped_class(
    'create_lookup', 
    CreateLookup, 
    nil
  )
  
  attr_accessor :identifier
  attr_accessor :value
  
  def initialize(params)
    super(params)
    @identifier = params[:identifier]
    unless $tables.has_key?(@identifier)
      $tables[@identifier] = params[:value]
      @value = params[:value]
    else
      raise "duplicate table definition #{params[:name]}"
    end
  end

  def param_keys
    []
  end
  
  def arduino_code
    []
  end

  def top_level_scope_code
    [
      "long #{@identifier}[#{@value.length}][3] = #{table_to_cplusplus_array(@value)};"
    ]
  end
  
  def table_to_cplusplus_array(t)
    "{#{t.map {|f| f.to_s.gsub(/\[/, '{').gsub(/\]/, '}') }.join(',')}}"
  end
end


def resolve_lookup(val)
  puts val
  puts val.class
  raise "table definition must be an array" unless val.class == Array
  val.map do |v|
    case
      when [Integer, Float].include?(v.class)
        then 3.times.map { scale_correctly(v) }
      when v.class == Array then v.map { |i| scale_correctly(i) }
    end
  end
end

def create_table_ref(identifier, value)
  h = ArbolHash.new
  h[:type] = 'create_lookup'
  h[:identifier] = identifier
  h[:value] = resolve_lookup(value)
  h
end