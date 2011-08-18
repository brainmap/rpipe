require 'rubygems'
require 'rake'
require 'bundler/gem_tasks'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rpipe"
    gem.summary = %Q{Neuroimaging preprocessing the Ruby way}
    gem.description = %Q{Neuroimaging preprocessing the Ruby way}
    gem.email = "kjkosmatka@gmail.com"
    gem.homepage = "http://github.com/brainmap/rpipe"
    gem.authors = ["Kristopher Kosmatka", "Erik Kastman"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "metamri", '~>0.2.8'
    gem.add_dependency "log4r"
    gem.add_dependency "POpen4"
    gem.add_dependency "ruport"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new do |test|
    test.warning = true
    # test.rcov = true
    test.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  task :spec do
    abort "RSpec is not available.  In order to run specs, you must: sudo gem install rspec"
  end
end


task :test => :check_dependencies

task :default => [:spec, :test]

begin
  gem 'darkfish-rdoc'
  require 'darkfish-rdoc/rdoctask'
rescue LoadError
  "Not using darkfish."
end
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rpipe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options += ['darkfish'] 
end
