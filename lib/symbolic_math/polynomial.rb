require_relative 'term'

module SymbolicMath
  class Polynomial
    attr_reader :terms
    
    def initialize(terms = [])
      @terms = terms.reject { |t| t.coefficient == 0 }
      simplify!
    end
    
    def to_s
      return "0" if @terms.empty?
      @terms.map(&:to_s).join(" + ").gsub("+ -", "- ")
    end
    
    def simplify!
      # Группируем одинаковые члены
      grouped = @terms.group_by { |t| [t.variable, t.exponent] }
      @terms = grouped.map do |(var, exp), terms|
        coeff = terms.sum(&:coefficient)
        Term.new(coeff, var, exp) if coeff != 0
      end.compact
      @terms.sort_by! { |t| -t.exponent }
    end
    
    def differentiate
      Polynomial.new(@terms.map(&:derivative))
    end
    
    def integrate
      Polynomial.new(@terms.map(&:integral))
    end
    
    # Подстановка значения переменной
    def substitute(variable, value)
      result = 0.0
      
      @terms.each do |term|
        if term.variable == variable
          result += term.coefficient * (value ** term.exponent)
        elsif term.variable.nil?
          result += term.coefficient
        end
      end
      
      result
    end
    
    # Подстановка с возвратом полинома
    def substitute_to_polynomial(variable, value)
      new_terms = @terms.map do |term|
        if term.variable == variable
          Term.new(term.coefficient * (value ** term.exponent), nil, 0)
        else
          term
        end
      end
      
      Polynomial.new(new_terms)
    end
    
    # Сложение полиномов
    def +(other)
      all_terms = @terms + other.terms
      Polynomial.new(all_terms)
    end
    
    # Вычитание полиномов
    def -(other)
      negative_terms = other.terms.map do |term|
        Term.new(-term.coefficient, term.variable, term.exponent)
      end
      all_terms = @terms + negative_terms
      Polynomial.new(all_terms)
    end
    
    # Умножение полинома на член
    def multiply_by_term(term)
      new_terms = @terms.map do |t|
        new_coeff = t.coefficient * term.coefficient
        
        if t.variable == term.variable
          new_exp = t.exponent + term.exponent
          Term.new(new_coeff, t.variable, new_exp)
        elsif t.variable.nil?
          Term.new(new_coeff, term.variable, term.exponent)
        elsif term.variable.nil?
          Term.new(new_coeff, t.variable, t.exponent)
        else
          # Разные переменные
          Term.new(new_coeff, nil, 0)  # Упрощённо
        end
      end
      Polynomial.new(new_terms)
    end
    
    # Умножение двух полиномов
    def *(other)
      return multiply_by_term(other) if other.is_a?(Term)
      return multiply_by_polynomial(other) if other.is_a?(Polynomial)
      raise "Unsupported multiplication type"
    end
    
    def multiply_by_polynomial(other)
      result_terms = []
      @terms.each do |t1|
        other.terms.each do |t2|
          new_coeff = t1.coefficient * t2.coefficient
          
          if t1.variable == t2.variable
            new_exp = t1.exponent + t2.exponent
            result_terms << Term.new(new_coeff, t1.variable, new_exp)
          elsif t1.variable.nil?
            result_terms << Term.new(new_coeff, t2.variable, t2.exponent)
          elsif t2.variable.nil?
            result_terms << Term.new(new_coeff, t1.variable, t1.exponent)
          else
            result_terms << Term.new(new_coeff, nil, 0)
          end
        end
      end
      Polynomial.new(result_terms)
    end
    
    # Упрощение выражения
    def simplify
      simplified_terms = @terms.map do |term|
        simplify_term(term)
      end
      
      simplified_terms.reject! { |t| t.coefficient == 0 }
      
      grouped = simplified_terms.group_by { |t| [t.variable, t.exponent] }
      final_terms = grouped.map do |(var, exp), terms|
        coeff = terms.sum(&:coefficient)
        Term.new(coeff, var, exp) if coeff != 0
      end.compact
      
      Polynomial.new(final_terms)
    end
    
    private
    
    def simplify_term(term)
      # Упрощаем 1*x → x
      if term.coefficient == 1 && term.exponent == 1 && term.variable
        return Term.new(1, term.variable, 1)
      end
      term
    end
  end
end
