require 'helper_spec'
require 'matlab_queue'
require 'pp'

describe "Test Matlab Queue Operations" do
  before(:each) do
    @q = q = MatlabQueue.new
  end
  
  it "should add a command" do  
    @q.length.should equal 0

    @q.commands << "1 + 2"
    @q.length.should equal 1
    
    @q.commands << "2 + 3"
    @q.length.should equal 2
    
    @q.to_s.should == "1 + 2; 2 + 3"
  end
  
  it "should add to the path" do
    @q.paths.length.should equal 0
    @q.paths << File.dirname(__FILE__)
    @q.paths.length.should equal 1
  end
  
  it "should generate a good string with paths and commands" do
    @q.paths << File.dirname(__FILE__)
    @q.commands << "1 + 2"
    @q.to_s.should == "addpath(genpath('#{File.dirname(__FILE__)}')); 1 + 2"
  end
  
  it "should run matlab successfully." do
    @q.paths << File.dirname(__FILE__)
    @q.commands << "1 + 2"
    @q.run!.should be_true
    @q.success.should be_true
  end
end