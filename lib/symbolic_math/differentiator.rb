module SymbolicMath
  class Differentiator
    def self.differentiate(expr, variable)
      case expr
      when Polynomial
        differentiate_polynomial(expr, variable)
      when Term
        differentiate_term(expr, variable)
      else
        raise "Unsupported expression type: #{expr.class}"
      end
    end
    

    def self.differentiate_polynomial(poly, variable)
      new_terms = poly.terms.map do |term|
        differentiate_term(term, variable)
      end
      Polynomial.new(new_terms)
    end
    
    
    def self.differentiate_term(term, variable)
      return Term.new(0) if term.variable != variable && term.variable != nil
      
      if term.variable.nil?  # константа
        Term.new(0)
      else
        term.derivative
      end
    end
    
    
    def self.product_rule(f, g, variable)
      # (f * g)' = f' * g + f * g'
      f_prime = differentiate(f, variable)
      g_prime = differentiate(g, variable)
      
      
      {
        type: :sum,
        left: { type: :product, left: f_prime, right: g },
        right: { type: :product, left: f, right: g_prime }
      }
    end
    

    def self.quotient_rule(f, g, variable)
      # (f / g)' = (f' * g - f * g') / g^2
      f_prime = differentiate(f, variable)
      g_prime = differentiate(g, variable)
      
      numerator_left = multiply(f_prime, g)
      numerator_right = multiply(f, g_prime)
      numerator = subtract(numerator_left, numerator_right)
      denominator = power(g, 2)
      
      divide(numerator, denominator)
    end
    
    private
    
    def self.multiply(a, b)
      { type: :product, left: a, right: b }
    end
    
    def self.subtract(a, b)
      { type: :subtract, left: a, right: b }
    end
    
    def self.divide(a, b)
      { type: :divide, left: a, right: b }
    end
    
    def self.power(base, exp)
      { type: :power, left: base, right: exp }
    end
  end
end