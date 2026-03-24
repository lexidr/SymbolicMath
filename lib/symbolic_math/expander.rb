require_relative 'polynomial'
require_relative 'term'

module SymbolicMath
  class Expander
    def self.expand(expr)
      case expr
      when Polynomial
        expand_polynomial(expr)
      when Array
        expand_expression(expr)
      else
        expr
      end
    end
    
    
    def self.expand_polynomial(poly)
      poly
    end
    
    def self.expand_product(left, right)
      left_terms = extract_terms(left)
      right_terms = extract_terms(right)
      
      result_terms = []
      left_terms.each do |lt|
        right_terms.each do |rt|
          result_terms << multiply_terms(lt, rt)
        end
      end
      
      Polynomial.new(result_terms)
    end
    
    def self.expand_square(expr)
      terms = extract_terms(expr)
      
      if terms.size == 2
        a = terms[0]
        b = terms[1]
        
        a_squared = multiply_terms(a, a)
        b_squared = multiply_terms(b, b)
        ab = multiply_terms(a, b)
        two_ab = Term.new(2 * ab.coefficient, ab.variable, ab.exponent)
        
        Polynomial.new([a_squared, two_ab, b_squared])
      else
        expand_product(expr, expr)
      end
    end
    
    private
    
    
    def self.extract_terms(expr)
      case expr
      when Polynomial
        expr.terms
      when Term
        [expr]
      else
        []
      end
    end
    
    
    def self.multiply_terms(term1, term2)
      new_coeff = term1.coefficient * term2.coefficient
      
      if term1.variable == term2.variable
        new_exp = term1.exponent + term2.exponent
        Term.new(new_coeff, term1.variable, new_exp)
      elsif term1.variable.nil?
        Term.new(new_coeff, term2.variable, term2.exponent)
      elsif term2.variable.nil?
        Term.new(new_coeff, term1.variable, term1.exponent)
      else
        
        raise "Multiplication of different variables not supported yet"
      end
    end
  end
end