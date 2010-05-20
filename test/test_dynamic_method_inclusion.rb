require 'helper'
require 'pp'

class TestDynamicMethodInclusion < Test::Unit::TestCase
  should "reconstruct raw data" do
    pipe = RPipe.new('drivers/mrt00015_hello.yml')
		r = pipe.recon_jobs.first
		r.hello
  end
end
