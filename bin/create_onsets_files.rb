#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'optparse'
require 'logfile'
require 'pathname'

def create!
  # Parse CLI Options and Spec File
  cli_options = parse_options
  
  # Extract Onsets Files from Log Text Files
  while ARGV.size >= 1
    begin
      filename = ARGV.shift
      basename = File.basename(filename)
    
      log = Logfile.new(filename, *cli_options[:conditions])
      puts log.to_csv
      log.write_csv(basename + '.csv')
      log.write_mat(filename)
    rescue StandardError => e
      puts "Problem creating onsets for #{filename}"
      puts e 
      puts e.backtrace if cli_options[:verbose]
    end
  end
  
end


def parse_options
  options = { :config => {} }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename(__FILE__)} [options] RAWDIR(S)"

    opts.on('-f', '--files FILES', "Logfiles to Extract onsets from")     do |files| 
      options[:logfiles] = files.gsub(" ", "").split(',')
    end
    
    opts.on('-c', '--conditions CONDITIONS', "Conditions to extract onsets for") do |conditions_arg|
      options[:conditions] = conditions_arg.gsub(" ", "").split(",").collect(&:to_sym)
    end
    
    opts.on('-f', '--force', "Overwrite onsets files if they exist.") do
      options[:force] = true
    end
    
    opts.on('-v', '--verbose', "Print extra info.") do
      options[:verbose] = true
    end
    
    

    opts.on_tail('-h', '--help', "Show this message")  { puts(parser); exit }
    opts.on_tail("Example: #{File.basename(__FILE__)} -c 'old, new' pdt00020_bac_081910_faces3_recognitionA.txt pdt00045_lms_112210_faces3_recognitionB.txt")
  end
  parser.parse!(ARGV)

  if ARGV.size == 0
    puts "Problem with arguments - Missing Logfiles to extract!"
    puts(parser); exit
  end
  
  if options[:conditions].empty?
    puts "Missing conditions - specify them with -c 'new, old' "
    puts(parser); exit
  end
  
  return options
end

# All that for this.
create!
