module DefaultRecon
	
	# Reconstructs, strips, and slice timing corrects all scans specified in the recon_spec.
	# This function assumes a destination directory is set up in the filesystem and begins writing
	# to it with no further checking.	 It will overwrite data if it already exists, be careful.
	def recon_visit
		
		setup_directory(@origdir, "RECON")
		
		Dir.chdir(@origdir) do
			@scans.each do |scan_spec|
				outfile = "%s_%s.nii" % [@subid, scan_spec['label']]
				
				reconstruct_scan(scan_spec, 'tmp.nii')
				
				if scan_spec['type'] == "func"
					strip_leading_volumes('tmp.nii', outfile, @volume_skip, scan_spec['bold_reps'])
					slice_time_correct(outfile)
				else
					File.copy('tmp.nii', outfile)
				end
				
				File.delete('tmp.nii')
			end
		end
	end
	
	# Reconstructs a scan from dicoms to nifti, anatomical or functional.	 Uses a scan_spec hash to drive.
	# Writes the result in current working directory. Raises an error if to3d system call fails.
	# Conventions: I****.dcm filenaming, I0002.dcm is second file in series, 
	def reconstruct_scan(scan_spec, outfile)
		scandir = File.join(@rawdir, scan_spec['dir'])
		
		# second_file = File.join(scandir, 'I0002.dcm')
		# wildcard = File.join(scandir,'I*dcm')
		
		second_file = Dir.glob( File.join(scandir, "*0002*") )
		wildcard = File.join(scandir, "*.[0-9]*")
		
		recon_cmd_format = 'to3d -skip_outliers %s -prefix tmp.nii "%s"'

		timing_opts = timing_options(scan_spec, second_file)
		
		flash "Reconstruction: #{scandir}"
		
		unless system(recon_cmd_format % [timing_opts, wildcard])
			raise(IOError,"Failed to reconstruct scan: #{scandir}")
		end
	end
	
	# Determines the proper timing options to pass to to3d for functional scans.	Must pass a static path to
	# the second file in the series to determine zt vs tz ordering.	 Assumes 2sec TR's.	 Returns the options
	# as a string that may be empty if the scan is an anatomical.
	def timing_options(scan_spec, second_file)
		return "" if scan_spec['type'] == "anat"
		instance_offset = scan_spec['z_slices'] + 1
		if system("dicom_hdr #{second_file} | grep .*REL.Instance.*#{instance_offset}")
			return "-epan -time:tz #{scan_spec['bold_reps']} #{scan_spec['z_slices']} 2000 alt+z"
		else
			return "-epan -time:zt #{scan_spec['z_slices']} #{scan_spec['bold_reps']} 2000 alt+z"
		end
	end
	
	# Removes the specified number of volumes from the beginning of a 4D functional nifti file.
	# In most cases this will be 3 volumes. Writes result in current working directory.
	def strip_leading_volumes(infile, outfile, volume_skip, bold_reps)
		flash "Stripping #{volume_skip.to_s} leading volumes: #{infile}"
		system("fslroi #{infile} #{outfile} #{volume_skip.to_s} #{bold_reps.to_s}")
	end
	
	# Uses to3d to slice time correct a 4D functional nifti file.	 Writes result in the current working directory.
	def slice_time_correct(infile)
		flash "Slice Timing Correction: #{infile}"
		system("3dTshift -tzero 0 -tpattern alt+z -prefix a#{infile} #{infile}")
	end
	
end