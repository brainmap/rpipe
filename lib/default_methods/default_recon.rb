require 'metamri/core_additions'
require 'pathname'
require 'default_methods/recon/raw_sequence'
# require 'default_methods/recon/physionoise_helper'

module DefaultRecon
	DEFAULT_VOLUME_SKIP = 3 # Default number of volumes to strip from beginning of functional scans.

	# Reconstructs, strips, and slice timing corrects all scans specified in the recon_spec.
	# This function assumes a destination directory is set up in the filesystem and begins writing
	# to it with no further checking.	 It will overwrite data if it already exists, be careful.
	def recon_visit
		
		setup_directory(@origdir, "RECON")
		
		Dir.chdir(@origdir) do		  
			@scans.each_with_index do |scan_spec, i|
				outfile = "%s_%s.nii" % [@subid, scan_spec['label']]
				
        # Set Discarded Acquisitions - Volumes to Skip from Recon Spec, Scan Spec or Default
				@volumes_to_skip = @volume_skip || scan_spec['volume_skip'] || scan_spec['volumes_to_skip'] || DEFAULT_VOLUME_SKIP
				
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
		  sequence = DicomRawSequence.new(scan_spec, @rawdir, @volumes_to_skip)
	  elsif scan_spec['pfile']
	    sequence = PfileRawSequence.new(scan_spec, @rawdir, @volumes_to_skip)
    else
      raise ConfigError, "Scan must list either a pfile or a dicom directory."
    end
    
    sequence.prepare(outfile)
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