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
	
	# Links all the files necessary from the "proc" directory. Links written to current working directory.
	def link_files_from_proc_directory
		images_wildcard = File.join(@procdir, "swa*.nii")
		motion_regressors_wildcard = File.join(@procdir, "md_rp*.txt")
		system("ln -s #{images_wildcard} #{@statsdir}")
		system("ln -s #{motion_regressors_wildcard} #{@statsdir}")
	end
	
	# Links to a preconfigured onsets file, a matlab file that contains three cell arrays: names, onsets, durations.
	# This file is used by SPM to configure the conditions of the function task and the onset times to use in the model.
	# Link is written to current working directory.
	def link_onsets_files
		@onsetsfiles.each do |ofile|
			opath = File.join(@studydir, 'onsets', ofile)
			system("ln -s #{opath} #{@procdir}")
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
	
end