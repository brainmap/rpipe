# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rpipe/version"

Gem::Specification.new do |s|
  s.name = %q{rpipe}
  s.version = Rpipe::VERSION
  
  s.summary = %Q{Neuroimaging preprocessing the Ruby way}
  s.description = %Q{Functional MRI Processing Pipeline for the WADRC}
  s.email = "ekk@medicine.wisc.edu"
  s.homepage = "http://github.com/brainmap/rpipe"
  s.authors = ["Kristopher Kosmatka", "Erik Kastman"]

  s.add_development_dependency "thoughtbot-shoulda", ">= 0"
  s.add_dependency "metamri", '~>0.2.9'
  s.add_dependency "log4r", '~>1.1.9'
  s.add_dependency "POpen4", '~>0.1.4'
  s.add_dependency "ruport", '~>1.6.3'
  

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
end

