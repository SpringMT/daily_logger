lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "daily_logger"
  gem.version       = "0.0.2"
  gem.authors       = ["Spring_MT"]
  gem.email         = ["today.is.sky.blue.sky@gmail.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{daily lotate logger}
  gem.homepage      = "https://github.com/SpringMT/daily_logger"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
end

