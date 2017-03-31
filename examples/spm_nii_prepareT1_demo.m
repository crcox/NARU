%% Load and prepare T1 from PAR/REC
% The data encoded in the PAR/REC files are oriented in an atypical way and
% does not have a meaningful origin set. The following is a guide on how to
% produce a well formed NIFTI file from these raw materials.

%% Load from PAR/REC
% Data are stored on disk as uint16 values (16-bit unsigned integers). The
% PAR header contains parameters to scale these integers to floating-point
% values, so we will extract these and combine them appropriately. It seems
% that the second dimension (anterior-posterior) needs to be flipped when
% reading from PAR/REC. Note that, at this point, the data has been read in
% as double-precision floating point values but it has not been scaled (so
% if you were to inspace T1.data, it would be composed entirely of whole
% numbers). 

[T1, T1_meta, T1_info] = load_parrec('D:\MRI\SoundPicture\data\PARREC\MRH026_201\MRH026_201_T1W_IR_1150_SENSE_3_1.PAR');

T1.data = fliplr(T1.data);

RI = T1(1).rescale_intercept;
RS = T1(1).rescale_slope;
SS = T1(1).scale_slope;
slope = 1/SS;
intercept = RI/(RS*SS);

r = scaleoffset_nii(T1(1), T1_meta);

%% Build the meta object
% Be sure to plug in the slope and intercept into pinfo, and set the
% data-type to uint16. This will ensure that the data on disk is the same
% as was stored in the PAR/REC, except that the AP dimension has been
% flipped (see above). The voxel dimensions get encoded along the diagonal
% of mat. The file name can be a full path, to make sure that the file is
% saved to a particular location. By including the extension nii, we tell
% SPM that we want to produce a NIFTI file.

hdr(1).fname = 'C:\Users\mbmhscc4\MATLAB\test_T1.nii';
hdr(1).dim = size(T1.data);
hdr(1).pinfo = [slope,intercept,352]';
hdr(1).dt = [spm_type('uint16'),0];
hdr(1).mat = r.mat;
% hdr(1).mat = eye(4);
% hdr(1).mat([1,6,11]) = volume_dim;
hdr(1).n = [];
hdr(1).descrip = '';
hdr(1).private = [];

%% Scale to floating point and write the NIFTI file.
% Even though we want the data to be stored on disk as whole-number uint16
% values, we need to scale to the floating point value. This is because
% when saving the values to disk, SPM will reverse the scaling encoded in
% pinfo. In general this is convenient, as it lets you seamlessly load data
% into the proper form/scaled values, and then write it back seamlessly as
% integers, if you so choose. We are only bothering with the integer
% encoding for the raw data. Once the analysis pipeline kicks off, all
% subsequent files will be stored as doubles.

d = (T1.data .* slope) + intercept;
x = spm_write_vol(hdr, d);
disp(x.mat);

%% Place the origin manually
% For anatomy/T1 scans, it might be easiest to look up the coordinates with
% MRIcron---the brain browser is much nicer. But updating the origin
% through this interface will ensure that it is being placed exactly where
% you want it and give you a chance to visually confirm that SPM and
% MRIcron are using coordinates in the same way.
spm_image('Display', x.fname)

%% Check your work
% The previous step should have altered the header of the NIFTI file
V = spm_vol(x.fname);
disp(V.mat);
spm_image('Display', V.fname)

% It is worth pointing out that this procedure does not perfectly replicate
% what dcm2niix does (yet...). It prefectly corresponds with
% nii_dicom.cpp:readParRec(), but the nifti file that is produced after
% that stage is different than the one produced here. But that is a mystery
% for another day. This is quite close.