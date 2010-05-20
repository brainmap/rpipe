require 'helper'
require 'pp'

class TestRecon < Test::Unit::TestCase
  should "reconstruct raw data" do
    pipe = RPipe.new('drivers/mrt00015.yml')
		#r = pipe.recon_jobs.first
		#r.recon_visit
		p = pipe.preproc_jobs.first
		p.preproc_visit
  end
end
