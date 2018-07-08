lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name     = 'roku-ecp'
  spec.version  = '0.1.0'
  spec.authors  = ['Jacob Evan Shreve']
  spec.email    = ['github@shreve.io']

  spec.summary  = 'A library for controlling Roku devices on your local network'
  spec.homepage = 'https://github.com/shreve/roku-ecp'
  spec.license  = 'MIT'

  spec.files    = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = ['roku']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.16.2'
end
