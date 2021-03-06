
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "specfac/version"

Gem::Specification.new do |spec|
  spec.name          = "specfactor"
  spec.version       = Specfac::VERSION
  spec.authors       = ["viktharien"]
  spec.email         = ["viktharien@zoho.com"]

  spec.summary       = %q{SpecFactor is a CLI for generating rspec controller tests. The gem is in a proof-of-concept stage.}
  spec.homepage      = "https://github.com/viktharien/specfacthor"
  spec.license       = "MIT"



  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "activesupport", "~> 5.2.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
end
