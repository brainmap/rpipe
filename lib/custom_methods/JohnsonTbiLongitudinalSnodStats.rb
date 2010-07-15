# require 'logfile'
module JohnsonTbiLongitudinalSnodStats

	DEFAULT_CONDITIONS = [:new, :old]
  
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
    @conditions = @conditions ? @conditions.collect {|c| c.to_sym if c.respond_to? :to_sym } : DEFAULT_CONDITIONS 
  end
  
  def create_or_link_onsets_files
    if @onsetsfiles.nil?
		  if @responses.nil?
		    raise ScriptError, "Condition vectors cannot be created because neither log response files nor onsets mat files have been specified."
	    else
	      @onsetsfiles = create_onsets_files(@responses, conditions)
      end
    else
	    link_onsets_files
		end
  end
  
  # Finally runs the stats job 
  def run_stats_spm_job
    images = @scan_labels ? @scan_labels.collect! { |label| Dir.glob("sw*#{label}*.nii").to_s } : Dir.glob(File.join(@origdir, "sw*#{@subid}*.nii"))
    raise ScriptError, "Can't find any smoothed, warped images in #{@statsdir}" if images.empty?
    unless @onsetsfiles.length == @regressorsfiles.length && @regressorsfiles.length == @bold_reps.length
      raise ScriptError, "Mismatch between #{@bold_reps.length} reps, #{@onsetsfiles.length} onsets and #{@regressorsfiles.length} regressors files."
    end
    
    queue = MatlabQueue.new
	  queue.paths << [
	    '/Applications/spm/spm8/spm8_current', 
	    '/apps/spm/spm8_current',
      File.join(@libdir, 'custom_methods'), 
      File.join(@libdir, 'matlab_helpers')    ]

	  queue << "JohnsonTbiLongitudinalSnodStats('#{@statsdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    { #{@onsetsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    { #{@regressorsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    'JohnsonTbiLongitudinalSnodStats_job.m')"
    
    # puts queue.to_s
    queue.run!
  end
  
end