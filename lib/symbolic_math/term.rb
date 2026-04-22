# frozen_string_literal: true

module SymbolicMath
  class Term
    attr_reader :coefficient, :variable, :exponent

    def initialize(coefficient, variable = nil, exponent = 0)
      @coefficient = coefficient.to_f
      @variable = variable
      @exponent = exponent.to_i

      if @exponent == 0
        @variable = nil
      end
    end

    def to_s
      return @coefficient.to_s if @exponent == 0
      return "#{@coefficient}*#{@variable}" if @exponent == 1
      "#{@coefficient}*#{@variable}^#{@exponent}"
    end

    def derivative
      return Term.new(0) if @exponent == 0
      Term.new(@coefficient * @exponent, @variable, @exponent - 1)
    end

    def integral(variable = 'x')
      # Константа: ∫ 5 dx = 5*x
      if @variable.nil?
        return Term.new(@coefficient, variable, 1)
      end

      # ∫ x^n dx = x^(n+1)/(n+1) для n != -1
      if @exponent == -1
        raise "Integration of 1/x not supported yet"
      end

      new_coefficient = @coefficient / (@exponent + 1).to_f
      Term.new(new_coefficient, @variable, @exponent + 1)
    end

    def ==(other)
      return false unless other.is_a?(Term)
      @coefficient == other.coefficient &&
        @variable == other.variable &&
        @exponent == other.exponent
    end
  end
end