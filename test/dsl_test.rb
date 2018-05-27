require 'minitest'
require 'minitest/autorun'

require_relative '../lib/arbol.rb'
require_relative '../lib/base.rb'
require_relative '../lib/dsl.rb'

class ArbolDSLTest < Minitest::Test
  def test_scale_correctly
    assert_equal(100, scale_correctly(100))
    assert_equal(8192, scale_correctly(1.0))
    assert_equal(0, scale_correctly(0))
    assert_equal(4096, scale_correctly(0.5))
  end
  
  def test_coerce_array
    assert_equal([1, 2, 3], coerce_array([1, 2, 3]))
    assert_equal([1, 1, 1], coerce_array(1))
  end
  
  def test_resolve
    assert_equal(
      { 
        type: 'const',
        value: [0, 0, 0]
      },
      resolve(0)
    )

    assert_equal(
      { 
        type: 'const',
        value: [8192, 8192, 8192]
      },
      resolve(1.0)
    )
      
    assert_equal(
      { 
        type: 'const',
        value: [8192, 8192, 0]
      },
      resolve([1.0, 8192, 0])
    )
    
    expected = ArbolHash.new
    expected[:turkey] = 'chicken'
    
    assert_equal(
      expected,
      resolve(expected)
    )
  end
  
  def test_remove_comments
    assert_equal(
      'hello',
      remove_comments('hello')
    )
    
    assert_equal(
      'hello ',
      remove_comments('hello # goofballs')
    )
    
    assert_equal(
      "hello \n\ngoodbye ",
      remove_comments("hello # goofballs\n# full line\ngoodbye #suckas")
    )
  end
end