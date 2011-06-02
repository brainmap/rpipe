#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'optparse'
require 'logfile'

def summarize!
  # Parse CLI Options and Spec File
  cli_options = parse_options  
  begin
    # Summarize a Directory of Logfiles
    Logfile.write_summary(cli_options[:filename], cli_options[:directory], cli_options[:grouping])
  rescue IOError => e
    puts e
  end
end

def parse_options
  options = { :filename => nil, :directory => nil, :grouping => nil}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename(__FILE__)} [options]"

    opts.on('-f', '--filename FILENAME', "Filename for summary (i.e. summary.csv")     do |filename| 
      options[:filename] = filename
    end
    
    opts.on('-d', '--directory DIRECTORY', "Directory containing Button-press Response Logfiles")     do |responses_dir| 
      options[:directory] = File.expand_path(responses_dir)
    end

    opts.on('-g', '--grouping', "Grouping variable for summary.") do |grouping|
      options[:grouping] = grouping
    end
    
    opts.on_tail('-h', '--help', "Show this message")  { puts(parser); exit }
    opts.on_tail("Example: #{File.basename(__FILE__)} -f johnson.predict.visit1.response_summary.csv")
  end
  parser.parse!(ARGV)
  
  unless ARGV.size == 0
    puts parser, "\n"
    
    puts "Sorry, didn't recognize #{ARGV.join(' or ')}"
    puts "Maybe add -f or -d?", "\n"

    exit
  end
  
  return options
end

# All that for this.
summarize!
