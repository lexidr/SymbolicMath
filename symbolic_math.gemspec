require_relative 'lib/symbolic_math/version'

Gem::Specification.new do |spec|
  spec.name = 'symbolic_math'
  spec.version = '0.1.0'
  spec.authors = ['Друк Александра', 'Лебедь Виолетта', 'Нейжмак Анастасия']

  spec.summary = 'Ruby gem for symbolic mathematics with polynomials'
  spec.description = 'A Ruby gem for symbolic mathematical transformations'
  spec.homepage = 'https://github.com/lexidr/SymbolicMath'
  spec.required_ruby_version = '>= 3.0.0'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
