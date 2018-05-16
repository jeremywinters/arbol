class Const < Base
  Irontofu.add_mapped_class('const', Const, nil)
  attr_accessor :value

  def initialize(params)
    super
    @value = params[:value]
  end

  def arduino_code
    []
  end

  def top_level_scope_code
    [
      "long #{@name}[3] = {#{@value.join(',')}};"
    ]
  end
end

# given a slightly different name to avoid
def my_const(value)
  {
    type: "const",
    value: coerce_array(value)
  }
end