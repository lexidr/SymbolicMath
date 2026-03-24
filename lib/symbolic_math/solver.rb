require_relative 'polynomial'
require_relative 'term'
require_relative 'parser'

module SymbolicMath
  class Solver
    def self.solve(equation, variable)
      # Если передана строка, парсим её
      if equation.is_a?(String)
        equation = parse_equation(equation)
      end
      
      # Определяем степень уравнения
      degree = find_degree(equation, variable)
      
      case degree
      when 0
        solve_constant(equation)
      when 1
        solve_linear(equation, variable)
      when 2
        solve_quadratic(equation, variable)
      else
        raise "Equation degree #{degree} not supported yet"
      end
    end
    
    # Решение линейного уравнения ax + b = 0
    def self.solve_linear(equation, variable)

      normalized = normalize_equation(equation)
      
      # Находим коэффициенты a и b
      a = 0.0
      b = 0.0
      
      normalized.terms.each do |term|
        if term.variable == variable
          a += term.coefficient
        elsif term.variable.nil?
          b += term.coefficient
        end
      end
      
      # Проверяем особые случаи
      if a == 0
        if b == 0
          return :infinite_solutions
        else
          return :no_solution
        end
      end
      
      solution = -b / a
      [solution]
    end
    
    private
    
    def self.parse_equation(str)
      # Разделяем по знаку "="
      parts = str.split('=')
      raise "Invalid equation format" unless parts.size == 2
      
      left = Parser.parse(parts[0].strip)
      right = Parser.parse(parts[1].strip)
      
      # Переносим всё в левую часть
      subtract_polynomials(left, right)
    end
    
    # Вычитает один полином из другого
    def self.subtract_polynomials(poly1, poly2)
      negative_terms = poly2.terms.map do |term|
        Term.new(-term.coefficient, term.variable, term.exponent)
      end
      
      # Объединяем члены
      all_terms = poly1.terms + negative_terms
      Polynomial.new(all_terms)
    end
    
    # убирает константы в правую часть
    def self.normalize_equation(equation)
      # Если уравнение уже в виде polynomial = 0, просто возвращаем
      equation
    end
    
    # Находит степень уравнения по переменной
    def self.find_degree(equation, variable)
      max_degree = 0
      equation.terms.each do |term|
        if term.variable == variable
          max_degree = [max_degree, term.exponent].max
        end
      end
      max_degree
    end
    
    # Решение уравнения-константы
    def self.solve_constant(equation)
      if equation.terms.empty? || equation.to_s == '0'
        return :all_reals
      else
        return :no_solution
      end
    end
  end
end