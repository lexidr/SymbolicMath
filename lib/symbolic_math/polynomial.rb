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
  end
end
