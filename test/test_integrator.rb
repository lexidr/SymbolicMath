require_relative 'test_helper'

class TestIntegrator < Minitest::Test
  def setup
    @integrator = SymbolicMath::Integrator
  end
  
  def test_integrate_constant
    poly = SymbolicMath::Parser.parse('5')
    result = @integrator.integrate(poly, 'x')
    assert_equal '5.0*x', result.to_s
  end
  
  def test_integrate_variable
    poly = SymbolicMath::Parser.parse('x')
    result = @integrator.integrate(poly, 'x')
    assert_equal '0.5*x^2', result.to_s
  end
  
  def test_integrate_power
    poly = SymbolicMath::Parser.parse('x^2')
    result = @integrator.integrate(poly, 'x')
    assert_equal '0.3333333333333333*x^3', result.to_s
  end
  
  def test_integrate_polynomial
    poly = SymbolicMath::Parser.parse('3*x^2 + 2*x + 1')
    result = @integrator.integrate(poly, 'x')
    assert_equal '1.0*x^3 + 1.0*x^2 + 1.0*x', result.to_s
  end
  
  def test_integrate_with_coefficient
    poly = SymbolicMath::Parser.parse('4*x^3')
    result = @integrator.integrate(poly, 'x')
    assert_equal '1.0*x^4', result.to_s
  end
  
  def test_definite_integral
    poly = SymbolicMath::Parser.parse('x^2')
    result = @integrator.definite_integral(poly, 'x', 0, 1)
    assert_in_delta 0.3333333333333333, result, 0.0001
  end
end