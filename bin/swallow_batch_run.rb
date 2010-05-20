#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rpipe'

yml_driver = ARGV[0]

p = RPipe.new(yml_driver)

exit

p.recon_jobs.each do |reconjob|
  reconjob.setup_destination_directory
  reconjob.recon_visit
end

p.preproc_jobs[0].setup_proc_dir
p.preproc_jobs[0..2].each do |pj|
  pj.link_files_into_proc
end
p.preproc_jobs[0].preproc_visit
p.preproc_jobs[3].preproc_visit