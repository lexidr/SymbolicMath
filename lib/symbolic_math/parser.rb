module SymbolicMath
  class Parser
    def self.parse(str)
      str = str.gsub(/\s+/, "")
      terms_str = str.split(/(?=[+-])/).map(&:strip)
      
      terms = terms_str.map do |term_str|
        parse_term(term_str)
      end
      
      Polynomial.new(terms)
    end
    
    private
    
    def self.parse_term(term_str)
      sign = 1
      if term_str.start_with?("-")
        sign = -1
        term_str = term_str[1..-1]
      elsif term_str.start_with?("+")
        term_str = term_str[1..-1]
      end
      
      if term_str.include?("*")
        coeff_part, var_part = term_str.split("*")
        coefficient = coeff_part.to_f * sign
        
        if var_part.include?("^")
          var, exp = var_part.split("^")
          exponent = exp.to_i
        else
          var = var_part
          exponent = 1
        end
        
        Term.new(coefficient, var, exponent)
      elsif term_str =~ /[a-zA-Z]/
        if term_str.include?("^")
          var, exp = term_str.split("^")
          exponent = exp.to_i
        else
          var = term_str
          exponent = 1
        end
        
        Term.new(sign, var, exponent)
      else
        Term.new(term_str.to_f * sign, nil, 0)
      end
    end
  end
end
