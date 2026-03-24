$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'minitest/autorun'
require 'symbolic_math'

class TestTerm < Minitest::Test
  def test_create_constant
    term = SymbolicMath::Term.new(5)
    assert_equal 5.0, term.coefficient
    assert_nil term.variable
    assert_equal 0, term.exponent
  end

  def test_create_variable
    term = SymbolicMath::Term.new(3, 'x', 1)
    assert_equal 3.0, term.coefficient
    assert_equal 'x', term.variable
    assert_equal 1, term.exponent
  end

  def test_create_power
    term = SymbolicMath::Term.new(2, 'x', 3)
    assert_equal 2.0, term.coefficient
    assert_equal 'x', term.variable
    assert_equal 3, term.exponent
  end

  def test_create_negative
    term = SymbolicMath::Term.new(-4, 'x', 2)
    assert_equal -4.0, term.coefficient
  end

  def test_to_s_constant
    term = SymbolicMath::Term.new(5)
    assert_equal '5.0', term.to_s
  end

  def test_to_s_variable
    term = SymbolicMath::Term.new(3, 'x', 1)
    assert_equal '3.0*x', term.to_s
  end

  def test_to_s_power
    term = SymbolicMath::Term.new(2, 'x', 3)
    assert_equal '2.0*x^3', term.to_s
  end

  def test_to_s_negative
    term = SymbolicMath::Term.new(-4, 'x', 2)
    assert_equal '-4.0*x^2', term.to_s
  end

  def test_derivative_constant
    term = SymbolicMath::Term.new(5)
    result = term.derivative
    assert_equal 0.0, result.coefficient
    assert_equal '0.0', result.to_s
  end

  def test_derivative_variable
    term = SymbolicMath::Term.new(3, 'x', 1)
    result = term.derivative
    assert_equal 3.0, result.coefficient
    assert_equal '3.0', result.to_s
  end

  def test_derivative_power
    term = SymbolicMath::Term.new(2, 'x', 3)
    result = term.derivative
    assert_equal 6.0, result.coefficient
    assert_equal 'x', result.variable
    assert_equal 2, result.exponent
    assert_equal '6.0*x^2', result.to_s
  end

  def test_integral_constant
    term = SymbolicMath::Term.new(5)
    result = term.integral
    assert_equal 5.0, result.coefficient
    assert_equal 'x', result.variable
    assert_equal 1, result.exponent
    assert_equal '5.0*x', result.to_s
  end

  def test_integral_variable
    term = SymbolicMath::Term.new(3, 'x', 1)
    result = term.integral
    assert_equal 1.5, result.coefficient
    assert_equal 'x', result.variable
    assert_equal 2, result.exponent
  end

  def test_integral_power
    term = SymbolicMath::Term.new(2, 'x', 3)
    result = term.integral
    assert_equal 0.5, result.coefficient
    assert_equal 'x', result.variable
    assert_equal 4, result.exponent
  end

  def test_equality_same
    term1 = SymbolicMath::Term.new(2, 'x', 3)
    term2 = SymbolicMath::Term.new(2, 'x', 3)
    assert_equal term1, term2
  end

  def test_equality_different
    term1 = SymbolicMath::Term.new(2, 'x', 3)
    term2 = SymbolicMath::Term.new(3, 'x', 3)
    refute_equal term1, term2
  end
end