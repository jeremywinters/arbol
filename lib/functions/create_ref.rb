$refs = {}

class CreateRef < Base
  Arbol.add_mapped_class('create_ref', CreateRef, nil)
  attr_accessor :identifier
  attr_accessor :value
  
  def initialize(params)
    super(params)
    @identifier = params[:identifier]
    unless $refs.has_key?(@identifier)
      $refs[@identifier] = @name
    else
      raise "duplicate ref definition #{params[:name]}"
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

def create_ref(identifier, value)
  h = ArbolHash.new
  h[:type] = 'create_ref'
  h[:identifier] = identifier
  h[:value] = resolve(value)
  h
end