# frozen_string_literal: true

require_relative "lib/hybridforest/version"

Gem::Specification.new do |spec|
  spec.name = "hybridforest"
  spec.version = HybridForest::VERSION
  spec.authors = ["hi-tech-jazz"]
  spec.email = ["jazztechhi@gmail.com"]

  spec.summary = "Hybrid random forest for binary classification tasks."
  spec.description = "HybridForest provides random forests built upon combinations of different decision tree algorithms to enable diverse tree ensembles. Until version 1.0.0, please expect breaking changes."
  spec.homepage = "https://github.com/hi-tech-jazz/hybridforest"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.2"

  spec.metadata["homepage_uri"] = "https://github.com/hi-tech-jazz/hybridforest"
  spec.metadata["source_code_uri"] = "https://github.com/hi-tech-jazz/hybridforest"
  spec.metadata["changelog_uri"] = "https://github.com/hi-tech-jazz/hybridforest/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "rubocop", "~> 1.7"
  spec.add_dependency "rumale"
  spec.add_dependency "activesupport", "~> 6.1"
  spec.add_dependency "rover-df", "~> 0.2.6"
  spec.add_dependency "require_all"
  spec.add_dependency "terminal-table", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rumale"
  spec.add_development_dependency "activesupport", "~> 6.1"
  spec.add_development_dependency "rover-df", "~> 0.2.6"
end
