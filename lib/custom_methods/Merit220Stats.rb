require 'logfile'
module Merit220Stats

	DEFAULT_CONDITIONS = [:new_correct_, :new_incorrect_, :old_correct_, :old_incorrect]
  
  # runs the complete set of tasks using data in a subject's "proc" directory and a preconfigured template spm job.
	def run_first_level_stats
		flash "Highway to the dangerzone..."
		setup_directory(@statsdir, "STATS")
		
		Dir.chdir(@statsdir) do
			link_files_from_proc_directory(File.join(@procdir, "sw*.nii"), File.join(@procdir, "rp*.txt"))
			setup_onsets
			run_stats_spm_job
		end
	end

	alias_method :perform, :run_first_level_stats
	
	def setup_onsets
	  setup_conditions
    create_or_link_onsets_files
  end
  
  def setup_conditions
    @conditions = @conditions ? @conditions.collect! {|c| c.to_sym} : DEFAULT_CONDITIONS 
  end
  
  def create_or_link_onsets_files
    if @onsetsfiles.nil?
		  if @responses.nil?
		    raise ScriptError, "Multiple conditions cannot be calculated because neither log response files nor onsets mat files have been defined."
	    else
	      puts @onsetsfiles = create_onsets_files(@responses, conditions)
      end
    else
	    link_onsets_files
		end
  end
  
  # Finally runs the stats job 
  def run_stats_spm_job
    images = Dir.glob(File.join(@statsdir, "sw*#{@subid}*task*.nii"))
    raise ScriptError, "Can't find any smoothed, warped images in #{@statsdir}" if images.empty?
    
    queue = MatlabQueue.new
	  queue.paths << ['/Applications/spm/spm8/spm8_current', 
      File.join(@root_dir, 'custom_methods'), 
      File.join(@root_dir, 'matlab_helpers')    ]

	  queue << "Merit220Stats('#{@statsdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    { #{@onsetsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    { #{@regressorsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    'Merit220Stats_job.m')"
    
    # puts queue.to_s
    queue.run!
  end
  
end