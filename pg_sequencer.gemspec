$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pg_sequencer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pg_sequencer"
  s.version     = PgSequencer::VERSION
  s.authors     = ["Tony Collen"]
  s.email       = ["tonyc@code42.com"]
  s.homepage    = "http://code42.com/"
  s.summary     = "Manage postgres sequences in Rails migrations"
  s.description = "Sequences need some love. pg_sequencer teaches Rails what sequences are, and will dump them to schema.rb, and also lets you create/drop sequences in migrations."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  # s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency 'activerecord', '>= 3.0.0'
  s.add_development_dependency 'activerecord', '>= 3.1.0'
  s.add_development_dependency "pg", "0.11.0"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-test"
  s.add_development_dependency "shoulda-context"
end
