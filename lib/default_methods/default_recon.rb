require 'metamri/core_additions'
require 'pathname'
require 'default_methods/recon/raw_sequence'
# require 'default_methods/recon/physionoise_helper'

module DefaultRecon
	
	# Reconstructs, strips, and slice timing corrects all scans specified in the recon_spec.
	# This function assumes a destination directory is set up in the filesystem and begins writing
	# to it with no further checking.	 It will overwrite data if it already exists, be careful.
	def recon_visit
		
		setup_directory(@origdir, "RECON")
		
		Dir.chdir(@origdir) do		  
			@scans.each_with_index do |scan_spec, i|
				outfile = "%s_%s.nii" % [@subid, scan_spec['label']]
				
				reconstruct_scan(scan_spec, outfile)
				
				if scan_spec['type'] == "func"
          # if scan_spec['physio_files']
          #   create_physiosnoise_regressors(scan_spec)
          #   outfile = run_retroicor(scan_spec['physio_files'], outfile)
          # end
				  
					slice_time_correct(outfile, scan_spec['alt_direction'] ||= 'alt+z')
				else
					File.copy('tmp.nii', outfile)
				end
				
				File.delete('tmp.nii') if File.exist? 'tmp.nii'
			end
		end
	end
	
	alias_method :perform, :recon_visit
	
  # Reconstructs a scan from dicoms or pfile to nifti, anatomical or functional.
  # Uses a scan_spec hash to drive. Writes the result in current working
  # directory. Raises an error if to3d system call fails. Conventions: I****.dcm
  # filenaming, I0002.dcm is second file in series,
	def reconstruct_scan(scan_spec, outfile)	
		if scan_spec['dir']
		  sequence = DicomRawSequence.new(scan_spec, @rawdir)
		  File.delete('tmp.nii') if File.exist? 'tmp.nii'
		  sequence.prepare('tmp.nii')
			strip_leading_volumes('tmp.nii', outfile, @volume_skip, scan_spec['bold_reps'])
	  elsif scan_spec['pfile']
	    sequence = PfileRawSequence.new(scan_spec, @rawdir)
	    sequence.prepare(outfile)
    else 
      raise ConfigError, "Scan must list either a pfile or a dicom directory."
    end
	end
	
	# Removes the specified number of volumes from the beginning of a 4D functional nifti file.
	# In most cases this will be 3 volumes. Writes result in current working directory.
	def strip_leading_volumes(infile, outfile, volume_skip, bold_reps)
		$Log.info "Stripping #{volume_skip.to_s} leading volumes: #{infile}"
		cmd_fmt = "fslroi %s %s %s %s"
		cmd_options = [infile, outfile, volume_skip.to_s, bold_reps.to_s]
		cmd = cmd_fmt % cmd_options
		unless run(cmd)
		  raise ScriptError, "Failed to strip volumes: #{cmd}"
	  end
	end
	
	# Uses to3d to slice time correct a 4D functional nifti file.	 Writes result in the current working directory.
	def slice_time_correct(infile, alt_direction = "alt+z")
		$Log.info "Slice Timing Correction: #{infile}"
		cmd = "3dTshift -tzero 0 -tpattern #{alt_direction} -prefix a#{infile} #{infile}"
		unless run(cmd)
		  raise ScriptError, "Failed to slice time correct: #{cmd}"
	  end
	end
	
end