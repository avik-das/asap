# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "asap/version"

Gem::Specification.new do |s|
  s.name        = "asap"
  s.version     = Asap::Gem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Greg Spurrier", "Avik Das"]
  s.email       = ["gspurrier@linkedin.com", "adas@linkedin.com"]
  s.homepage    = "http://rubygems.org/gems/didactic_clock"
  s.summary     = %q{A JRuby library for parallel fetches.}
  s.description = %q{A JRuby library for parallel fetches. Provides an embedded-domain specific language for declaring dependencies between resources.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("mongrel")

  s.add_development_dependency("rspec")
  s.add_development_dependency("rake")
  
  # Event machine does not run well on JRuby, but the main library requires
  # JRuby.  The following gems should be installed separately on an MRI
  # instance if you wish to run bin/asap-em-test-server
  # s.add_runtime_dependency('eventmachine')
  # s.add_runtime_dependency('eventmachine_httpserver')
end
