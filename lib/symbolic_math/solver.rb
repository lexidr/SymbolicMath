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
    
    # Решение квадратного уравнения ax^2 + bx + c = 0
    def self.solve_quadratic(equation, variable)
      normalized = normalize_equation(equation)
      
      # Находим коэффициенты a, b, c
      a = 0.0
      b = 0.0
      c = 0.0
      
      normalized.terms.each do |term|
        if term.variable == variable
          case term.exponent
          when 2
            a += term.coefficient
          when 1
            b += term.coefficient
          end
        elsif term.variable.nil?
          c += term.coefficient
        end
      end
      
      # Проверяем, что это квадратное уравнение
      if a == 0
        return solve_linear(equation, variable)
      end
      
      # Вычисляем дискриминант
      discriminant = b**2 - 4 * a * c
      
      if discriminant > 0
        sqrt_d = Math.sqrt(discriminant)
        x1 = (-b + sqrt_d) / (2 * a)
        x2 = (-b - sqrt_d) / (2 * a)
        # Сортируем корни по возрастанию
        [x1, x2].sort
      elsif discriminant == 0
        x = -b / (2 * a)
        [x]
      else
        :no_real_roots
      end
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
    
    # Нормализует уравнение
    def self.normalize_equation(equation)
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
        return :infinite_solutions
      else
        return :no_solution
      end
    end
  end
end