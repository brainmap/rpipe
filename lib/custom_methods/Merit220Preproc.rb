module Merit220Preproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
		setup_directory(@procdir, "PREPROC")
		
		Dir.chdir(@procdir) do
			link_files_into_proc
			run_matlab_queue(matlab_queue)
			deal_with_motion
		end
	end
	
	alias_method :perform, :preproc_visit
	
	private
	
	def matlab_queue
	  queue = []
	  images = Dir.glob(File.join(@origdir, "a#{@subid}*.nii"))
	  queue << add_matlab_paths(
      '/Applications/spm/spm8/spm8_current', 
      File.expand_path(File.dirname(__FILE__)), 
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'matlab_helpers'))
    )

	  queue << "Merit220Preproc('#{@procdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') }, \
    'Merit220Preproc_job.m')"
  end
  
end