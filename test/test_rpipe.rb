require 'helper'

class TestRPipe < Test::Unit::TestCase
  should "initialize a pipe from a yml spec file" do
    pipe = RPipe.new(File.join(File.dirname(__FILE__), 'drivers', 'mrt00015.yml'))

		assert_not_nil pipe.recon_jobs
		assert_not_nil pipe.preproc_jobs
		assert_not_nil pipe.stats_jobs

    assert_equal 'mrt00015', pipe.jobs.first.subid
    assert_equal '/tmp/mrt00015', pipe.jobs.first.rawdir
    assert_equal '/tmp/mrt00015_orig',  pipe.jobs.first.origdir
    assert_equal '/tmp/mrt00015_proc',  pipe.jobs.first.procdir
    assert_equal '/tmp/mrt00015_stats', pipe.jobs.first.statsdir
    assert_equal :destroy, pipe.jobs.first.collision_policy
    
  end
end
