function phillips2spm(parfile)
% PHILLIPS2SPM Parse Par/Rec files into SPM-Analyse .img/.hdr files.
% Unpacks the Par/Rec into volume files, and puts them into three folders:
%   - Short echo suffix 'filename_short'
%   - Long echo suffix 'filename_long'
%
% The resulting files can be used directly within SPM8/12, as required



% write out TE 12 images
for i = 1:gradientnhalf
currentdyn = te_short_4d(:,:,:,i);
currentdyn = squeeze(currentdyn);
for k=1:slicen
  currentdyn(:,:,k) = fliplr(currentdyn(:,:,k));
end
 numbext = num2str(i,'%04.0f');
savestring = [pname_a,fname1st_a,'_short\',numbext];
save_avw(savestring, currentdyn,16,outdim);
end

% write out TE 35 images
for i = 1:gradientnhalf
currentdyn = te_long_4d(:,:,:,i);
currentdyn = squeeze(currentdyn);
for k=1:slicen
  currentdyn(:,:,k) = fliplr(currentdyn(:,:,k));
end
 numbext = num2str(i,'%04.0f');
savestring = [pname_a,fname1st_a,'_long\',numbext];
save_avw(savestring, currentdyn,16,outdim);
end

toc

fprintf('Functional image volumes seperated.\n');
fprintf('Saved workspace (image parameters) in Short folder.\n');
fprintf('\n');

