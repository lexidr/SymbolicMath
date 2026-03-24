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

      if term.coefficient == 1 && term.exponent == 1
        return Term.new(1, term.variable, 1)
      end
  
      if term.exponent == 1
        return Term.new(term.coefficient, term.variable, 1)
      end
      term
    end
  end
end
