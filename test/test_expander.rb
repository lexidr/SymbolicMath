require_relative 'test_helper'

class TestExpander < Minitest::Test
  def setup
    @expander = SymbolicMath::Expander
  end
  
  
  def test_multiply_terms
    term1 = SymbolicMath::Term.new(2, 'x', 1)
    term2 = SymbolicMath::Term.new(3, 'x', 2)
    result = @expander.send(:multiply_terms, term1, term2)
    assert_equal 6.0, result.coefficient
    assert_equal 'x', result.variable
    assert_equal 3, result.exponent
  end
  
  def test_extract_terms_from_polynomial
    poly = SymbolicMath::Parser.parse('2*x^2 + 3*x + 1')
    terms = @expander.send(:extract_terms, poly)
    assert_equal 3, terms.size
  end
  
  def test_extract_terms_from_term
    term = SymbolicMath::Term.new(5, 'x', 2)
    terms = @expander.send(:extract_terms, term)
    assert_equal 1, terms.size
    assert_equal term, terms[0]
  end
  def test_expand_simple_product
    # (x + 1)*(x + 2) = x^2 + 3x + 2
    expr = SymbolicMath.parse_with_brackets("(x+1)*(x+2)")
    result = @expander.expand(expr)
    
    assert_equal 3, result.terms.size
    
    x2_term = result.terms.find { |t| t.exponent == 2 }
    assert_equal 1.0, x2_term.coefficient
    assert_equal 'x', x2_term.variable
    
    x_term = result.terms.find { |t| t.exponent == 1 }
    assert_equal 3.0, x_term.coefficient
    assert_equal 'x', x_term.variable
    
    const_term = result.terms.find { |t| t.variable.nil? }
    assert_equal 2.0, const_term.coefficient
  end
end