#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'optparse'
require 'pp'
require 'generators/workflow_generator'



def create!
  # Parse CLI Options and Spec File
  cli_options = parse_options
  spec_options = cli_options[:spec_file] ? load_spec(options[:spec_file]) : {}
  
  workflow_options_defaults = {}
  workflow_options = workflow_options_defaults.merge(spec_options).merge(cli_options[:config])

  # Create a Workflow Generator and use it to create configure job.
  rawdir = ARGV.pop
  workflow = WorkflowGenerator.new(rawdir, workflow_options)
  if cli_options[:dry_run]
    pp workflow.build
  else
    write_file(workflow.build)
  end
end



def write_file(workflow_spec, filename = nil)
  filename ||= workflow_spec['subid'] + '.yaml'
  
  File.open(filename, 'w') { |f| f.puts workflow_spec.to_yaml }
  raise IOError, "Couldn't write #{filename}}" unless File.exist?(filename)
end

def load_spec(spec_file)
  if File.exist?(spec_file)
    spec = YAML::load_file(spec_file)
  else
    raise IOError, "Cannot find yaml spec file #{spec_file}"
  end
  
  return spec
end

def parse_options
  options = { :config => {} }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename(__FILE__)} [options] RAWDIR"

    opts.on('-s', '--spec SPEC', "Spec File for common study parameters")     do |spec_file| 
      options[:spec_file] = spec_file
    end
    
    opts.on('-r', '--responses_dir RESPONSES_DIR', "Directory containing Button-press Response Logfiles")     do |responses_dir| 
      options[:config][:responses_dir.to_s] = responses_dir
    end

    opts.on('-d', '--dry-run', "Display Driver without executing it.") do
      options[:dry_run] = true
    end

    opts.on_tail('-h', '--help',          "Show this message")          { puts(parser); exit }
    opts.on_tail("Example: #{File.basename(__FILE__)} mrt00001")
  end
  parser.parse!(ARGV)

  if ARGV.size == 0
    puts "Problem with arguments - Missing RAWDIR"
    puts(parser); exit
  end
  
  return options
end

if __FILE__ == $0
  create!
end