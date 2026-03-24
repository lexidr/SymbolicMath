require_relative 'polynomial'
require_relative 'term'

module SymbolicMath
  class Integrator
    # Интегрирует выражение по переменной
    def self.integrate(expr, variable)
      case expr
      when Polynomial
        integrate_polynomial(expr, variable)
      when Term
        integrate_term(expr, variable)
      when Numeric
        Term.new(expr, variable, 1)
      else
        raise "Unsupported expression type: #{expr.class}"
      end
    end
    
    # Интегрирование полинома (суммы членов)
    def self.integrate_polynomial(poly, variable)
      new_terms = poly.terms.map do |term|
        integrate_term(term, variable)
      end
      Polynomial.new(new_terms)
    end
    
    # Интегрирование отдельного члена
    def self.integrate_term(term, variable)
      if term.variable != variable && term.variable != nil
        return Term.new(term.coefficient, variable, 1)
      end

      if term.variable.nil?
        return Term.new(term.coefficient, variable, 1)
      end
      
      if term.exponent == -1
        raise "Integration of 1/x not supported yet"
      end
      
      term.integral
    end
    
    def self.definite_integral(expr, variable, lower, upper)
      indefinite = integrate(expr, variable)
      upper_value = substitute_value(indefinite, variable, upper)
      lower_value = substitute_value(indefinite, variable, lower)
      
      upper_value - lower_value
    end
    
    private
    
    def self.substitute_value(expr, variable, value)
      case expr
      when Polynomial
        expr.substitute(variable, value)
      when Term
        if expr.variable == variable
          expr.coefficient * (value ** expr.exponent)
        else
          expr.coefficient * value
        end
      when Numeric
        expr
      else
        0.0
      end
    end
  end
end