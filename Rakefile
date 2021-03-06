require 'rubygems'
require 'rake'
require 'bundler/gem_tasks'

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
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rpipe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options += ['darkfish'] 
end
