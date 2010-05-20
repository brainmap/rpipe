module Merit220Preproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
    # setup_proc_dir
		Dir.chdir(@procdir) do
			link_files_into_proc
			run_matlab_queue(matlab_queue)
			deal_with_motion
		end
	end
	
	private
	
	def matlab_queue
	  matlab_queue = []
	  images = Dir.glob(File.join(@origdir, "a#{@subid}*.nii"))
	  matlab_queue << "addpath(genpath('/Applications/spm/spm8/spm8_current')); addpath('#{@origdir}')"
	  matlab_queue << "merit_preproc('#{@procdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { 164 164 164}, \
    '/private/tmp/mrt00015_orig/mrt00015_preproc_job.m')"
  end
  
  def run_matlab_queue(queue)
    system("matlab -nosplash -nodesktop -r \"#{ queue.join('; ') }; exit\" ")
  end
end