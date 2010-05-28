require 'rubygems'
require 'yaml'
require 'ftools'
require 'fileutils'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'custom_methods'))

# prevent zipping in FSL programs
ENV['FSLOUTPUTTYPE'] = 'NIFTI'


class JobStep
	
	COLLISION_POLICY = :panic # options -- :panic, :destroy, :overwrite
	
	attr_accessor :subid, :rawdir, :origdir, :procdir, :statsdir, :spmdir, :collision_policy
	
	# Intialize with two configuration option hashes - workflow_spec and job_spec
	def initialize(workflow_spec, job_spec)
		# allow jobspec to override the workflow spec
		@subid    = job_spec['subid']     || workflow_spec['subid']
		@rawdir   = job_spec['rawdir']    || workflow_spec['rawdir']
		@origdir  = job_spec['origdir']   || workflow_spec['origdir']
		@procdir  = job_spec['procdir']   || workflow_spec['procdir']
		@statsdir = job_spec['statsdir']  || workflow_spec['statsdir']
		@spmdir   = job_spec['spmdir']    || workflow_spec['spmdir']
		@collision_policy = (job_spec['collision'] || workflow_spec['collision'] || COLLISION_POLICY).to_sym
		include_custom_methods(job_spec['method'])
	end
	
	# Dynamically load custom methods for advanced processing.
	def include_custom_methods(module_name)
		if module_name.nil? or ['default','wadrc'].include?(module_name)
			# do nothing, use default implementation
		else
			require module_name
			extend self.class.const_get(module_name)
		end
	end
	
	# displays a message and the date/time to standard output.
	def flash(msg)
		puts
		puts "+" * 120
		printf "\t%s\n", msg
		printf "\t%s\n", Time.now
		puts "+" * 120
		puts
	end
	
	# Setup directory path according to collision policy.
	def setup_directory(path, logging_tag)
		if File.exist?(path)
			if @collision_policy == :destroy
				puts "#{logging_tag} :: Deleting directory #{path}"
				FileUtils.rm_rf(path)
				FileUtils.mkdir(path)
			elsif @collision_policy == :overwrite
				puts "#{logging_tag} :: Overwriting inside directory #{path}"
			else
				raise(IOError, "Directory already exists, exiting: #{path}")
			end
		else
			puts "#{logging_tag} :: Creating new directory #{path}"
			FileUtils.mkdir(path)
		end
	end
	
end



########################################################################################################################
# A class for performing initial reconstruction of both functional and anatomical MRI scan acquisitions.
# Uses AFNI to convert from dicoms to 3D or 4D nifti files, initial volume stripping, and slice timing correction.
# Currently, only dicom raw data is supported, and only supports the I****.dcm file naming convention.
class Reconstruction < JobStep
	require 'default_recon'
	include DefaultRecon
	
	VOLUME_SKIP = 3 # number of volumes to strip from beginning of functional scans.
	
	attr_accessor :scans, :volume_skip
	
	# Instances are initialized with a properly configured hash containing all the information needed to drive
	# reconstruction tasks.	 This hash is normally generated with a Pipe object.
	def initialize(workflow_spec, recon_spec)
		super(workflow_spec, recon_spec)
		@scans = recon_spec['scans']
		@volume_skip = recon_spec['volume_skip'] || VOLUME_SKIP
	end

end
###############################################	 END OF CLASS	 #########################################################




########################################################################################################################
# A class for performing spatial preprocessing steps on functional MRI data in preparation for first level stats.
# Preprocessing includes setting up output directories, linking all appropriate data, customizing a preconfigured spm
# job, running the job, calculating withing scan motion derivatives, and finally checking for excessive motion.
# The spm job should normally include tasks for realignment, normalization, and smoothing. 
class Preprocessing < JobStep
	require 'default_preproc'
	include DefaultPreproc

	MOTION_THRESHOLD = 1 # maximum allowable realignment displacement in any direction

	attr_accessor :tspec, :motion_threshold, :bold_reps

	# Initialize instances with a hash normally generated by a Pipe object.
	def initialize(workflow_spec, preproc_spec)
		super(workflow_spec, preproc_spec)
		@tspec = preproc_spec['template_spec']
		@motion_threshold = preproc_spec['motion_threshold'] || MOTION_THRESHOLD
		@bold_reps = preproc_spec['bold_reps']
	end

end
###############################################	 END OF CLASS	 #########################################################





########################################################################################################################
# A class used to compute the first level stats for a functional MRI visit data set.
# Currently very incomplete, any ideas for other data/attributes we need here?
class Stats < JobStep
	require 'default_stats'
	include DefaultStats
	
	attr_accessor :statsdir, :tspec, :onsetsfile, :bold_reps
	
	# Initialize instances with a hash normally generated by a Pipe object.
	def initialize(workflow_spec, stats_spec)
		super(workflow_spec, stats_spec)
		@tspec = stats_spec['template_spec']
		@onsetsfiles = stats_spec['onsetsfiles']
		@regressorsfiles = stats_spec['regressorsfiles']
		@bold_reps = stats_spec['bold_reps']
	end
	
end
###############################################	 END OF CLASS	 #########################################################





########################################################################################################################
# An object that drives all the other pipeline classes in this module.	Once initialized, an array of instances of each
# class are available to run segments of preprocessing.
class RPipe
	
	attr_accessor :recon_jobs, :preproc_jobs, :stats_jobs, :workflow_spec
	
	# To initialize an instance create a yaml configuration file and pass the filename to the constructor
	# Yaml drivers contain a list of entries, each of which contains all the information necessary to create an instance
	# the proper object that executes the job.	Details on the formatting of the yaml drivers including examples will be
	# provided in other documentation.
	# Raises an error if the file is not found in the file system.
	def initialize(driver_file)
		@recon_jobs = []
		@preproc_jobs = []
		@stats_jobs = []
		
		raise(IOError, "Driver file not found: #{driver_file}") unless File.exist?(driver_file)
		@workflow_spec = YAML.load_file(driver_file)
		
		jobs = @workflow_spec['jobs']
		
		jobs.each do |job_params|
			@recon_jobs   << Reconstruction.new(@workflow_spec, job_params) if job_params['step'] == 'reconstruct'
			@preproc_jobs << Preprocessing.new(@workflow_spec, job_params)  if job_params['step'] == 'preprocess'
			@stats_jobs   << Stats.new(@workflow_spec, job_params)          if job_params['step'] == 'stats'
		end
		
		def jobs
		  [@recon_jobs, @preproc_jobs, @stats_jobs].flatten
	  end
	end
	
end
###############################################	 END OF CLASS	 #########################################################
