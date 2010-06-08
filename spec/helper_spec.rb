begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

require 'tmpdir'
require 'fileutils'
require 'yaml'
require 'pp'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'custom_methods')))
require 'rpipe'


#### Add Directory Comparisons to Dir ####
class Dir
  def self.compare_directories(dir1, dir2)
    d1 = Dir.entries(dir1).sort
    d2 = Dir.entries(dir2).sort

    d1.should == d2
    d1.each_with_index do |entry, i|
      next if entry.to_s =~ /\.*/ 
      File.compare(entry, d2[i]).should be_true
    end

  end
end