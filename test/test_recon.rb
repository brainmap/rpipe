require 'helper'
require 'pp'

class TestRecon < Test::Unit::TestCase
  should "reconstruct raw data" do
		driver = ARGV[0] ||= File.join(File.dirname(__FILE__), 'drivers', 'mrt00015.yml')
    pipe = RPipe.new(driver)
		r = pipe.recon_jobs.first
		r.recon_visit
  end
end
