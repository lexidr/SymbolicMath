require_relative 'symbolic_math/version'
require_relative 'symbolic_math/term'
require_relative 'symbolic_math/polynomial'
require_relative 'symbolic_math/parser'
require_relative 'symbolic_math/differentiator'
require_relative 'symbolic_math/integrator'
require_relative 'symbolic_math/expander'
require_relative 'symbolic_math/solver'

module SymbolicMath
  class Error < StandardError; end
  
  def self.parse(string)
    Parser.parse(string)
  end
  
  def self.solve(equation, variable)
    Solver.solve(equation, variable)
  end
  def self.parse_with_brackets(string)
    Expander.expand(string)
  end
end
