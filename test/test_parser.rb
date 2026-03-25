# frozen_string_literal: true

require_relative 'test_helper'

class TestParser < Minitest::Test
  #  Тесты для констант 

  def test_parse_constant
    poly = SymbolicMath::Parser.parse('5')
    assert_equal '5.0', poly.to_s
  end

  def test_parse_negative_constant
    poly = SymbolicMath::Parser.parse('-5')
    assert_equal '-5.0', poly.to_s
  end

  #  Тесты для переменных 

  def test_parse_variable
    poly = SymbolicMath::Parser.parse('x')
    assert_equal '1.0*x', poly.to_s
  end

  def test_parse_negative_variable
    poly = SymbolicMath::Parser.parse('-x')
    assert_equal '-1.0*x', poly.to_s
  end

  #  Тесты для степеней 

  def test_parse_power
    poly = SymbolicMath::Parser.parse('x^3')
    assert_equal '1.0*x^3', poly.to_s
  end

  def test_parse_coefficient_with_power
    poly = SymbolicMath::Parser.parse('2*x^3')
    assert_equal '2.0*x^3', poly.to_s
  end

  #  Тесты для полиномов 

  def test_parse_polynomial
    poly = SymbolicMath::Parser.parse('2*x^2 + 3*x + 1')
    assert_equal '2.0*x^2 + 3.0*x + 1.0', poly.to_s
  end

  def test_parse_polynomial_with_minus
    poly = SymbolicMath::Parser.parse('2*x^2 - 3*x + 1')
    assert_equal '2.0*x^2 - 3.0*x + 1.0', poly.to_s
  end

  def test_parse_polynomial_with_negative_first
    poly = SymbolicMath::Parser.parse('-2*x^2 + 3*x - 1')
    assert_equal '-2.0*x^2 + 3.0*x - 1.0', poly.to_s
  end

  #  Тесты с пробелами 

  def test_parse_with_spaces
    poly = SymbolicMath::Parser.parse(' 2*x^2  +  3*x  +  1 ')
    assert_equal '2.0*x^2 + 3.0*x + 1.0', poly.to_s
  end

  #  Тесты для разных переменных 

  def test_parse_different_variable
    poly = SymbolicMath::Parser.parse('3*y^2 + 2*y + 1')
    assert_equal '3.0*y^2 + 2.0*y + 1.0', poly.to_s
  end

  #  Тесты для сложных случаев 

  def test_parse_only_x
    poly = SymbolicMath::Parser.parse('x')
    assert_equal '1.0*x', poly.to_s
  end

  def test_parse_x_squared
    poly = SymbolicMath::Parser.parse('x^2')
    assert_equal '1.0*x^2', poly.to_s
  end

  def test_parse_x_plus_x
    poly = SymbolicMath::Parser.parse('x + x')
    assert_equal '2.0*x', poly.to_s
  end
end