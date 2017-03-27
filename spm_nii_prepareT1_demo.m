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
voxel_dim = [T1(1).pixel_spacing,T1(1).slice_thickness + T1(1).slice_gap];
stackOffcentre = T1_meta.Off_Centre_midslice;

%% SETUP THE INITIAL ROTATION MATRIX
% NB. The following are adapted from dcm2niix:nii_dicom.cpp#1523:1585
%
% First, convert degrees to radians and compute sine and cosine of the
% angles.
ca = [...
    cos(deg2rad(T1_meta.Angulation_midslice(1))),...
    cos(deg2rad(T1_meta.Angulation_midslice(2))),...
    cos(deg2rad(T1_meta.Angulation_midslice(3)))...
];
sa = [...
    sin(deg2rad(T1_meta.Angulation_midslice(1))),...
    sin(deg2rad(T1_meta.Angulation_midslice(2))),...
    sin(deg2rad(T1_meta.Angulation_midslice(3)))...
];
rx = [1.0, 0.0, 0.0; 0.0, ca(1), -sa(1); 0.0, sa(1), ca(1)];
ry = [ca(2), 0.0, sa(2); 0.0, 1.0, 0.0; -sa(2), 0.0, ca(2)];
rz = [ca(3), -sa(3), 0.0; sa(3), ca(3), 0.0; 0.0, 0.0, 1.0];
R = (rx * ry) * rz;

kSliceOrientTra = 1;
kSliceOrientSag = 2;
kSliceOrientCor = 3;
sliceOrient = T1(1).slice_orientation;

ixyz = [1,2,3];
if sliceOrient == kSliceOrientSag
    ixyz = [2,3,1];
    for r = 1:3
        for c = 1:3
            if (c ~= 1), R(r,c) = -R(r,c), end; % invert first and final columns
        end
    end
elseif sliceOrient == kSliceOrientCor
	ixyz = [1,3,2];
	for r = 1:3
        R(r,3) = -R(r,3); % invert rows of final column
	end
end

R = R(:,ixyz); % dicom rotation matrix

orient = zeros(1,7);
orient(2) = R(1,1);
orient(3) = R(2,1);
orient(4) = R(3,1);
orient(5) = R(1,2);
orient(6) = R(2,2);
orient(7) = R(3,2);

dim_mat = zeros(3,3);
dim_mat([1,5,9]) = voxel_dim;
R = R * dim_mat;
R44 = eye(4);
R44(1:3,1:4) = [R, stackOffcentre'];

offset_mat = eye(4);
offset_mat(1:3,4) = (voxel_dim - 1) / 2;
R44 = R44 / offset_mat; % same as R44 * inv(offset_mat)
y_v = [0,0,voxel_dim(3) - 1, 1];
y_v = R44 * y_v';

iOri = 3; % for axial, slices are 3rd dimenson (indexed from 0) (k)
if (sliceOrient == kSliceOrientSag), iOri = 1, end; % for sagittal, slices are 1st dimension (i)
if (sliceOrient == kSliceOrientCor), iOri = 2, end; % for coronal, slices are 2nd dimension (j)
if  (( (y_v(iOri)-R44(iOri,4))>0 ) == ( (y_v(iOri)-stackOffcentre(iOri)) > 0 ) )
	patientPosition = R44(1:3,4);
	patientPositionLast = y_v(1:3);
else
    patientPosition = y_v(1:3);
    patientPositionLast = R44.m(1:3,4);
end


%% Build the meta object
% Be sure to plug in the slope and intercept into pinfo, and set the
% data-type to uint16. This will ensure that the data on disk is the same
% as was stored in the PAR/REC, except that the AP dimension has been
% flipped (see above). The voxel dimensions get encoded along the diagonal
% of mat. The file name can be a full path, to make sure that the file is
% saved to a particular location. By including the extension nii, we tell
% SPM that we want to produce a NIFTI file.

hdr(1).fname = 'C:\Users\mbmhscc4\MATLAB\test_T1_rot180.nii';
hdr(1).dim = size(T1.data);
hdr(1).pinfo = [slope,intercept,352]';
hdr(1).dt = [spm_type('uint16'),0];
hdr(1).mat = eye(4);
hdr(1).mat([1,6,11]) = voxel_dim;
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
% It might be easiest to look up the coordinates with MRIcron---the brain
% browser is much nicer. But updating the origin through this interface
% will ensure that it is being placed exactly where you want it and give
% you a chance to visually confirm that SPM and MRIcron are using
% coordinates in the same way.
spm_image('Display', x.fname)

%% Check your work
% The previous step should have altered the header of the NIFTI file
V = spm_vol(x.fname);
disp(V.mat);
spm_image('Display', V.fname)


