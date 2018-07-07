class Const < Base
  Arbol.add_mapped_class('const', Const, nil)
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

module Arbol
  class Documentation

  def const   
%{--
### const(value)

* **value** - input value to be used as a constant.

You can specify a constant explicity:

```
const(0.4)

or

const([0.1, 0.2, 0.3])
```

..but generally you specify constants directly as values. There is no advantage in using the function.


```
0.4

or

[0.1, 0.2, 0.3]
```
}
  end

  end
end


# given a slightly different name to avoid
def my_const(value)
  {
    type: "const",
    value: coerce_array(value)
  }
end