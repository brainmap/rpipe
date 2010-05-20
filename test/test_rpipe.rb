require 'helper'

class TestRpipe < Test::Unit::TestCase
  should "initialize a pipe from a yml spec file" do
    p = RPipe.new('mrt00015.yml')
		p.recon_jobs.first.hello
  end
end
