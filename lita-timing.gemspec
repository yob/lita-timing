Gem::Specification.new do |spec|
  spec.name = "lita-timing"
  spec.version = "0.3.0"
  spec.summary = "Utilities for time related tasks in lita"
  spec.description = "Provides utilities that help with repeating tasks and rate limits"
  spec.license = "MIT"
  spec.files =  Dir.glob("{lib}/**/**/*")
  spec.extra_rdoc_files = %w{README.md MIT-LICENSE }
  spec.authors = ["James Healy"]
  spec.email   = ["james.healy@theconversation.edu.au"]
  spec.homepage = "http://github.com/yob/lita-timing"
  spec.required_ruby_version = ">=1.9.3"

  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec", "~> 3.4")
  spec.add_development_dependency("pry")
  spec.add_development_dependency("rdoc")
end
