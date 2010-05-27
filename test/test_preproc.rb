require 'helper'
require 'pp'

class TestRecon < Test::Unit::TestCase
  should "preprocess raw data" do
		driver = ARGV[0] ||= File.join(File.dirname(__FILE__), 'drivers', 'mrt00015.yml')
    pipe = RPipe.new(driver)
		p = pipe.preproc_jobs.first
		p.preproc_visit
  end
end