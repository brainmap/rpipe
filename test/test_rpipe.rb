require 'helper'

class TestRPipe < Test::Unit::TestCase
  should "initialize a pipe from a yml spec file" do
    p = RPipe.new('drivers/mrt00015.yml')
    assert_equal 'mrt00015', p.jobs.first.subid
    assert_equal '/tmp/mrt00015', p.jobs.first.rawdir
    assert_equal '/tmp/mrt00015_orig',  p.jobs.first.origdir
    assert_equal '/tmp/mrt00015_proc',  p.jobs.first.procdir
    assert_equal '/tmp/mrt00015_stats', p.stats_jobs.first.statsdir
    assert_equal :destroy, p.jobs.first.collision_policy
    
		assert_not_nil p.recon_jobs
		assert_not_nil p.preproc_jobs
		assert_not_nil p.stats_jobs
  end
end
