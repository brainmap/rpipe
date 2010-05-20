module Merit220Preproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
		setup_proc_dir
		Dir.chdir(@procdir) do
			link_files_into_proc
			create_and_run_spm_job
      # customize_templates
      # run_spm_jobs
			deal_with_motion
		end
	end
	

	private
	
	def create_and_run_spm_job
	  images = Dir.glob(@origdir, "a#{@subid}*.nii")
	  matlab_cmd = "/private/tmp/mrt00015_orig/merit_preproc('#{@procdir}', ...
    { #{images.join(' ')} }, ...
    { {164 164 164}, ...
    '/private/tmp/mrt00015_orig/mrt00015_preproc_job.m'); "

    
    
    system("matlab -r #{matlab_cmd}")
  end
	
end