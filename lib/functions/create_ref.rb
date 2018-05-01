$refs = {}

class CreateRef < Base
  Irontofu.add_mapped_class('create_ref', CreateRef, nil)
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
    [
      "long #{@name} = #{@value.name};"
    ]
  end
end

def create_ref(identifier, value)
  {
    type: 'create_ref',
    identifier: identifier,
    value: resolve(value)
  }
end