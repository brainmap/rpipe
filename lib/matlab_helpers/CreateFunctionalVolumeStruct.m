function volume_struct = CreateFunctionalVolumeStruct(studypath, image, bold_reps)

volume_struct = cell(bold_reps,1);
for vol = 1:bold_reps
	volume_struct{vol} = strcat(studypath, image, ',', int2str(vol));
end
