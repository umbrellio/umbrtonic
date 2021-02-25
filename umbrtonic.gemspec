# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "umbrtonic/version"

Gem::Specification.new do |spec|
  spec.name          = "umbrtonic"
  spec.version       = Umbrtonic::VERSION
  spec.authors       = ["Umbrellio Team", "Eugene Yak"]
  spec.email         = ["oss@umbrellio.biz", "eugene.yak@umbrellio.biz"]

  spec.summary       = "Gem for transferring Active Support Instrumentation events " \
                       "to the InfluxDB database via UDP without boilerplate code."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "influxdb"
  spec.add_runtime_dependency "qonfig"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-config-umbrellio"
end
