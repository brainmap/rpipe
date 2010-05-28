require 'matlab_queue'
module Merit220Preproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
		setup_directory(@procdir, "PREPROC")
		
		Dir.chdir(@procdir) do
			link_files_into_proc
			puts self
      run_preproc_mfile
			deal_with_motion
		end
	end
	
	alias_method :perform, :preproc_visit
	
	private
	
	def run_preproc_mfile
	  images = Dir.glob(File.join(@origdir, "a#{@subid}*.nii"))
	  raise ScriptError, "Can't find any slice-time corrected images in #{@origdir}" if images.empty?
	  queue = MatlabQueue.new
	  queue.paths << ['/Applications/spm/spm8/spm8_current', 
      File.expand_path(File.dirname(__FILE__)), 
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'matlab_helpers'))
    ]

	  queue << "Merit220Preproc('#{@procdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    'Merit220Preproc_job.m')"
    
    puts queue.to_s
    queue.run!
  end
  
end