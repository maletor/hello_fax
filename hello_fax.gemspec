# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hello_fax/version"

Gem::Specification.new do |s|
  s.name        = "hello_fax"
  s.license     = "MIT"
  s.version     = HelloFax::VERSION
  s.authors     = ["Ellis Berner"]
  s.email       = ["eberner@doximity.com"]
  s.homepage    = "https://github.com/maletor/hello_fax"
  s.summary     = %q{wrapper for HelloFax api}
  s.description = %q{Uses HTTMultiParty for interfacing with HelloFax to send and receive faxes, buy fax lines and more.}

  s.rubyforge_project = "hello_fax"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httmultiparty", "~> 0.3.5"

  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "fakeweb", "~> 1.3.0"
end
