########################################################################################################################
# A class for parsing a data directory and creating default Driver Configurations
class WorkflowGenerator
  attr_reader :spec
  
  def initialize(rawdir, config = Hash.new)
    @rawdir = rawdir
    @config = config
    @spec = Hash.new
  end
  
  def build
    return @spec
  end
end