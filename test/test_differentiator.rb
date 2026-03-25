require_relative 'test_helper'

class TestDifferentiator < Minitest::Test
  def setup
    @diff = SymbolicMath::Differentiator
  end
  
  def test_differentiate_constant
    poly = SymbolicMath::Parser.parse('5')
    result = @diff.differentiate(poly, 'x')
    assert_equal '0', result.to_s
  end
  
  def test_differentiate_variable
    poly = SymbolicMath::Parser.parse('x')
    result = @diff.differentiate(poly, 'x')
    assert_equal '1.0', result.to_s
  end
  
  def test_differentiate_polynomial
    poly = SymbolicMath::Parser.parse('3*x^2 + 2*x + 1')
    result = @diff.differentiate(poly, 'x')
    assert_equal '6.0*x + 2.0', result.to_s
  end
  
  def test_differentiate_product_simple
    poly1 = SymbolicMath::Parser.parse('x')
    poly2 = SymbolicMath::Parser.parse('x')
    
    # (x * x)' = 2x
    result = @diff.product_rule(poly1, poly2, 'x')
    assert_equal :sum, result[:type]
  end
  
  def test_differentiate_with_simplification
    poly = SymbolicMath::Parser.parse('x^3 + 3*x^2')
    result = @diff.differentiate(poly, 'x')
    simplified = result.simplify
    assert_equal '3.0*x^2 + 6.0*x', simplified.to_s
  end
end