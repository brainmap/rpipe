require 'matlab_helpers/matlab_queue'
module JohnsonMerit220Visit1Preproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
		setup_directory(@procdir, "PREPROC")
		
		Dir.chdir(@procdir) do
			link_files_into_proc
			check_permissions(image_files)
      run_preproc_mfile
			deal_with_motion
		end
	end
	
	alias_method :perform, :preproc_visit
	
	private
	
	def image_files
	  @image_files ||= Dir.glob(File.join(@origdir, "a*#{@subid}*.nii"))
	end
	
	def run_preproc_mfile
	  raise ScriptError, "Can't find any slice-time corrected images in #{@origdir}" if image_files.empty?

	  validate_existence_of @image_files

	  queue = MatlabQueue.new
	  queue.paths << [
	    @spmdir,
	    File.join(@spmdir, 'config'),
	    File.join(@spmdir, 'matlabbatch'),
	    File.expand_path(File.join(@libdir, 'custom_methods')), 
      File.expand_path(File.join(@libdir, 'matlab_helpers')) ]

	  queue << "JohnsonMerit220Visit1Preproc('#{@procdir}/', \
    { #{image_files.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    'JohnsonMerit220Visit1Preproc_job.m')"
    
    queue.run!
  end
  
end