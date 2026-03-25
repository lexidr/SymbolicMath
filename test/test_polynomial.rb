require_relative 'test_helper'

class TestPolynomial < Minitest::Test
  def setup
    @poly = SymbolicMath::Polynomial.new([
      SymbolicMath::Term.new(2, 'x', 2),
      SymbolicMath::Term.new(3, 'x', 1),
      SymbolicMath::Term.new(1, nil, 0)
    ])
  end

  #  Создание 

  def test_create_polynomial
    assert_equal 3, @poly.terms.size
    assert_equal '2.0*x^2 + 3.0*x + 1.0', @poly.to_s
  end

  def test_create_empty_polynomial
    poly = SymbolicMath::Polynomial.new([])
    assert_equal '0', poly.to_s
  end

  #  to_s 

  def test_to_s_single_term
    terms = [SymbolicMath::Term.new(5, 'x', 2)]
    poly = SymbolicMath::Polynomial.new(terms)
    assert_equal '5.0*x^2', poly.to_s
  end

  def test_to_s_constant
    terms = [SymbolicMath::Term.new(5, nil, 0)]
    poly = SymbolicMath::Polynomial.new(terms)
    assert_equal '5.0', poly.to_s
  end

  #  Упрощение 

  def test_simplify_like_terms
    terms = [
      SymbolicMath::Term.new(2, 'x', 2),
      SymbolicMath::Term.new(3, 'x', 2),
      SymbolicMath::Term.new(1, 'x', 1),
      SymbolicMath::Term.new(2, 'x', 1),
      SymbolicMath::Term.new(5, nil, 0),
      SymbolicMath::Term.new(3, nil, 0)
    ]
    poly = SymbolicMath::Polynomial.new(terms)
    assert_equal '5.0*x^2 + 3.0*x + 8.0', poly.to_s
  end

  def test_simplify_cancel
    terms = [
      SymbolicMath::Term.new(2, 'x', 2),
      SymbolicMath::Term.new(-2, 'x', 2),
      SymbolicMath::Term.new(3, 'x', 1)
    ]
    poly = SymbolicMath::Polynomial.new(terms)
    assert_equal '3.0*x', poly.to_s
  end

  #  Дифференцирование 

  def test_differentiate_polynomial
    result = @poly.differentiate
    assert_equal '4.0*x + 3.0', result.to_s
  end

  def test_differentiate_constant
    terms = [SymbolicMath::Term.new(5, nil, 0)]
    poly = SymbolicMath::Polynomial.new(terms)
    result = poly.differentiate
    assert_equal '0', result.to_s
  end

  #  Интегрирование 

  def test_integrate_polynomial
    result = @poly.integrate
    assert_equal '0.6666666666666666*x^3 + 1.5*x^2 + 1.0*x', result.to_s
  end

  def test_integrate_constant
    terms = [SymbolicMath::Term.new(5, nil, 0)]
    poly = SymbolicMath::Polynomial.new(terms)
    result = poly.integrate
    assert_equal '5.0*x', result.to_s
  end

  #  Подстановка 

  def test_substitute_value
    result = @poly.substitute('x', 2)
    assert_equal 15.0, result  # 2*4 + 3*2 + 1 = 15
  end

  def test_substitute_zero
    result = @poly.substitute('x', 0)
    assert_equal 1.0, result
  end

  #  Сложение 

  def test_add_polynomials
    poly2 = SymbolicMath::Polynomial.new([
      SymbolicMath::Term.new(1, 'x', 2),
      SymbolicMath::Term.new(2, 'x', 1),
      SymbolicMath::Term.new(3, nil, 0)
    ])
    result = @poly + poly2
    assert_equal '3.0*x^2 + 5.0*x + 4.0', result.to_s
  end

  #  Вычитание 

  def test_subtract_polynomials
    poly2 = SymbolicMath::Polynomial.new([
      SymbolicMath::Term.new(1, 'x', 2),
      SymbolicMath::Term.new(2, 'x', 1),
      SymbolicMath::Term.new(3, nil, 0)
    ])
    result = @poly - poly2
    assert_equal '1.0*x^2 + 1.0*x - 2.0', result.to_s
  end
end