module DefaultStats
	
	# runs the complete set of tasks using data in a subject's "proc" directory and a preconfigured template spm job.
	def run_first_level_stats
		flash "Highway to the dangerzone..."
		setup_directory(@statsdir, "STATS")
		
		Dir.chdir(@statsdir) do
			link_files_from_proc_directory
			link_onsets_files
			customize_template_job
			run_stats_spm_job
		end
		
	end
	
	alias_method :perform, :run_first_level_stats
	
	# Links all the files necessary from the "proc" directory. Links written to current working directory.
	def link_files_from_proc_directory(images_wildcard = File.join(@procdir, "swq*.nii"), motion_regressors_wildcard = File.join(@procdir, "md_rp*.txt"))
		system("ln -s #{images_wildcard} #{@statsdir}")
		system("ln -s #{motion_regressors_wildcard} #{@statsdir}")
	end
	
	# Links to a preconfigured onsets file, a matlab file that contains three cell arrays: names, onsets, durations.
	# This file is used by SPM to configure the conditions of the function task and the onset times to use in the model.
	# Link is written to current working directory.
	def link_onsets_files
		@onsetsfiles.each do |ofile|
			# Check if File Path is Absolute.  If not link from procdir/onsets
			opath = File.expand_path(ofile) == ofile ? ofile : File.join(@procdir, 'onsets', ofile)
			system("ln -s #{File.expand_path(opath)} #{Dir.pwd}")
		end
	end
	
	# Copies the template job to the current working directory, then customizes it by performing a set of recursive 
	# string replacements specified in the template_spec.
	def customize_template_job
		# TODO
	end
	
	# Finally runs the stats job and writes output to current working directory.
	def run_stats_spm_job
		# TODO
	end
	
	# Responses is a hash containing a directory and filenames of the .txt
	# button-press response logfiles formatted by Presentation's SDF.
	#
	# responses = { 'directory' => '/path/to/files', 'logfiles' => ['subid_taskB.txt', 'subid_taskA.txt']}
	def create_onsets_files(responses, conditions)
	  onsets_mat_files = []
	  Dir.chdir responses['directory'] do
	    responses['logfiles'].each do |logfile|
  	    # Either Strip off the prefix directly without changing the name...
        #   prefix = File.basename(logfile, '.txt')
        # Or create a new name based on standard logfile naming scheme:
        # mrt00000_abc_021110_faces3_recognitionA.txt
        prefix = File.basename(logfile, '.txt').split("_").values_at(0,3,4).join("_")
  	    log = Logfile.new(logfile, *conditions)
        # puts log.to_csv
  	    log.write_csv(prefix + '.csv')
  	    onsets_mat_files << log.write_mat(prefix)
      end
    end
    
    return onsets_mat_files
  end
  
	
end