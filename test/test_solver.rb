require_relative 'test_helper'

class TestSolver < Minitest::Test
  def setup
    @solver = SymbolicMath::Solver
  end
  
  # Тесты для линейных уравнений
  def test_solve_linear_simple
    result = @solver.solve('2*x + 3 = 7', 'x')
    assert_equal [2.0], result
  end
  
  def test_solve_linear_with_negative
    result = @solver.solve('3*x - 5 = 10', 'x')
    assert_equal [5.0], result
  end
  
  def test_solve_linear_with_fraction
    result = @solver.solve('0.5*x + 2 = 4', 'x')
    assert_equal [4.0], result
  end
  
  def test_solve_linear_both_sides
    result = @solver.solve('2*x + 3 = 5*x - 6', 'x')
    assert_equal [3.0], result
  end
  
  def test_solve_linear_no_solution
    result = @solver.solve('2*x + 3 = 2*x + 5', 'x')
    assert_equal :no_solution, result
  end
  
  def test_solve_linear_infinite_solutions
    result = @solver.solve('2*x + 3 = 2*x + 3', 'x')
    assert_equal :infinite_solutions, result
  end
  
  # Тесты для квадратных уравнений
  def test_solve_quadratic_two_roots
    result = @solver.solve('x^2 - 5*x + 6 = 0', 'x')
    # Сортируем для сравнения, так как порядок может быть разным
    assert_equal [2.0, 3.0], result.sort
  end
  
  def test_solve_quadratic_one_root
    result = @solver.solve('x^2 - 4*x + 4 = 0', 'x')
    assert_equal [2.0], result
  end
  
  def test_solve_quadratic_no_real_roots
    result = @solver.solve('x^2 + x + 1 = 0', 'x')
    assert_equal :no_real_roots, result
  end
  
  def test_solve_quadratic_with_negative
    result = @solver.solve('x^2 + 2*x - 8 = 0', 'x')
    assert_equal [-4.0, 2.0], result.sort
  end
  
  def test_solve_quadratic_with_coefficient
    result = @solver.solve('2*x^2 - 8*x + 6 = 0', 'x')
    assert_equal [1.0, 3.0], result.sort
  end
  
  def test_solve_quadratic_auto_detect
    result = @solver.solve('x^2 = 4', 'x')
    assert_includes result, 2.0
    assert_includes result, -2.0
  end
  
  # Тесты для подстановки
  def test_substitute_value
    poly = SymbolicMath::Parser.parse('3*x^2 + 2*x + 1')
    result = poly.substitute('x', 2)
    assert_equal 17.0, result
  end
  
  def test_substitute_zero
    poly = SymbolicMath::Parser.parse('5*x')
    result = poly.substitute('x', 0)
    assert_equal 0.0, result
  end
  
  def test_substitute_negative
    poly = SymbolicMath::Parser.parse('x^2')
    result = poly.substitute('x', -3)
    assert_equal 9.0, result
  end
  
  def test_substitute_to_polynomial
    poly = SymbolicMath::Parser.parse('3*x^2 + 2*y + 1')
    result = poly.substitute_to_polynomial('x', 2)
    # Проверяем, что результат содержит 2.0*y
    assert_includes result.to_s, '2.0*y'
    # Проверяем, что константа равна 13 (12 + 1)
    const_term = result.terms.find { |t| t.variable.nil? }
    if const_term
      assert_equal 13.0, const_term.coefficient
    end
  end
end