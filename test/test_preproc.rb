require 'helper'
require 'pp'

class TestRecon < Test::Unit::TestCase
  should "reconstruct raw data" do
		driver = ARGV[0]
    pipe = RPipe.new(driver)
		p = pipe.preproc_jobs.first
		p.preproc_visit
  end
end