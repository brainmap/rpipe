require 'helper'
require 'pp'

class TestRecon < Test::Unit::TestCase
  should "reconstruct raw data" do
		driver = ARGV[0]
    pipe = RPipe.new(driver)
		r = pipe.recon_jobs.first
		r.recon_visit
  end
end
