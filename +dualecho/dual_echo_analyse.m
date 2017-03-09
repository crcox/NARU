function dual_echo_analyse(pname_a,fname_a)

% Preprocessing of Par/Rec file into single image files (SPM-Analyse; .img .hdr)
% Unpacks the Par/Rec into volume files, and puts them into three folders:
%   - Short echo suffix 'filename_short'
%   - Long echo suffix 'filename_long'
%
% The resulting files can be used directly within SPM8, as required

% % add dual_echo folder to matlab path
% mbpath = fileparts(which('dual_echo.m'));
% code.ADDPATHS = {fullfile(mbpath)};
% addpath(code.ADDPATHS{:}, '-begin');
% fprintf('Dual-echo m.files added to matlab path\n');

funcstring = [pname_a,fname_a];
fname1st_a = strtok(fname_a, '.') ;   %find filename without extension

parfile = [pname_a,fname1st_a,'.PAR'];
fid = fopen(parfile);
s = textscan(fid,'%s','Delimiter','\n');
s = s{1};
a=s{300,1};
a=textscan(a,'%n','Delimiter','\n');
a=a{1};
slicen=s{22,1};
gradient=s{23,1};
slicen=str2num(slicen(end-2:end));
gradient=str2num(gradient(end-2:end));

x = a(10);
y = a(11);
outdim = a(29);
outdim(2) = a(30);
outdim(3) = a(23);
gradientn = 2 * gradient;
scalingfactor = a(14);
              
mkdir (pname_a,[fname1st_a,'_short']); 
mkdir (pname_a,[fname1st_a,'_long']); 
workspace_path = [pname_a,fname1st_a,'_short\workspace'];
save(workspace_path);

karls_rescalefactor = 1000;

gradientnhalf = round(gradientn/2);
num_elements = x * y * slicen * gradientn;
num_images = gradientn * slicen;

tic;
t=now;
fprintf('Started %s\n', datestr(t, 'dd mmmm yyyy, HH:MM:SS.FFF'));


fid = fopen(funcstring); %open data stream for rec file
img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16
dual4d = reshape(img,[x y slicen gradientn]);

%seperate TE 12 images
te_short_4d = zeros(x,y,slicen,gradientnhalf);
te_short_index = 1;
for i = 1:2:gradientn
te_short_4d(:,:,:,te_short_index) = dual4d(:,:,:,i);
te_short_4d(:,:,:,te_short_index) = (te_short_4d(:,:,:,te_short_index)/ scalingfactor) / karls_rescalefactor;
te_short_index = te_short_index + 1;
end

%seperate TE 35 images
te_long_4d = zeros(x,y,slicen,gradientnhalf);
te_long_index = 1;
for i = 2:2:gradientn
te_long_4d(:,:,:,te_long_index) = dual4d(:,:,:,i);
te_long_4d(:,:,:,te_long_index) =(te_long_4d(:,:,:,te_long_index)/ scalingfactor) / karls_rescalefactor;
te_long_index = te_long_index + 1;
end

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

