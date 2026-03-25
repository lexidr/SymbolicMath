require_relative 'polynomial'
require_relative 'term'

module SymbolicMath
  class Expander
    def self.expand(expr)
      case expr
      when String
        expand_string(expr)
      when Polynomial
        expr
      else
        expr
      end
    end
    
    def self.expand_string(str)
      str = str.gsub(/\s+/, "")
      
      if str.include?('*')
        parts = split_by_multiplication(str)
        polys = parts.map do |part|
          if part.include?('(')
            expand_string(part)
          else
            Parser.parse(part)
          end
        end
        result = polys.reduce do |product, poly|
          multiply_polynomials(product, poly)
        end
        
        result
      elsif str.include?('(')
        last_open = str.rindex('(')
        close = str.index(')', last_open)
        inner = str[last_open + 1...close]
        
        inner_poly = expand_string(inner)
        new_str = str[0...last_open] + inner_poly.to_s + str[close + 1..-1]
        expand_string(new_str)
      else
        Parser.parse(str)
      end
    end
    
    def self.split_by_multiplication(str)
      parts = []
      current = ""
      depth = 0
      
      str.each_char do |ch|
        if ch == '('
          depth += 1
          current << ch
        elsif ch == ')'
          depth -= 1
          current << ch
        elsif ch == '*' && depth == 0
          parts << current
          current = ""
        else
          current << ch
        end
      end
      parts << current if current != ""
      parts
    end
    
    def self.multiply_polynomials(p1, p2)
      result_terms = []
      p1.terms.each do |t1|
        p2.terms.each do |t2|
          result_terms << multiply_terms(t1, t2)
        end
      end
      Polynomial.new(result_terms)
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
  end
end