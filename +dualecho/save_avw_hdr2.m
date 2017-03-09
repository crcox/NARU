function HDR = save_avw_hdr2(fname, AVW, DATATYPE, DIMS)

% HDR = SAVE_AVW_HDR2(fname, AVW) 
% HDR = SAVE_AVW_HDR2(fname, AVW, DATATYPE) 
% HDR = SAVE_AVW_HDR2(fname, AVW, DATATYPE, DIMS) 
%
% DESCRIPTION:
%
% Creates an analyse header structure from defaults and given values.
% Also writes the created header to the file "fname.hdr".
%
% PARAMETERS:
%	AVW [height, width, depth, ...]: the matrix of voxel intensities, used to work out the dimensions.
%	DATATYPE [1]: the data type, the following values are supported:
%			2 = unsigned char (8 bits per voxel)
% 			4 = signed short (16 bits per voxel)
% 			8 = signed int (32 bits per voxel)
% 			16 = float (32 bits per voxel)
% 			64 = double (64 bits per voxel) (default if not given)
% 	DIMS [3 or 4 depending on the dimensions of the AVW]: the physical dimensions of the voxels, in mm.

if ( (length(findstr(fname,'.hdr'))>0) | (length(findstr(fname,'.img')>0)) )
        fname=fname(1:(length(fname)-4));
end

fname = strcat(fname, '.hdr');

DataTypeSizes(1) = 1;
DataTypeSizes(2) = 8;
DataTypeSizes(4) = 16;
DataTypeSizes(8) = 32;
DataTypeSizes(16) = 32;
DataTypeSizes(64) = 64;

HDR.dims = size(AVW);

ndims = length(HDR.dims);
if (length(HDR.dims) < 3)
	%HDR.dims(3) = 3;
    HDR.dims(3) = 1;   %HAH 26/07/2004
end

if (length(HDR.dims) < 4)
	HDR.dims(4) = 1;
end

switch nargin
	case 2
		HDR.datatype = 64; % datatype shall be double by default
		HDR.scales(1:3) = 1;
		HDR.scales(4) = 0;
	case 3
		HDR.datatype = DATATYPE;
		HDR.scales(1:3) = 1;
		HDR.scales(4) = 0;
	case 4
		HDR.datatype = DATATYPE;
		
		if length(DIMS) == length(size(AVW))
			if length(DIMS) == 2   %HAH 26/07/2004 to cope with output of single slice
                HDR.scales(1:2) = DIMS;   %HAH 26/07/2004
                HDR.scales(3) = 1;   %HAH 26/07/2004
                HDR.scales(4) = 0;   %HAH 26/07/2004
                %if length(DIMS) == 3
            elseif length(DIMS) == 3   %HAH 26/07/2004
				HDR.scales(1:3) = DIMS;
				HDR.scales(4) = 0;
			elseif length(DIMS) == 4
				HDR.scales(1:4) = DIMS;
			end
		else
			error('The dimensions vector DIMS has the wrong number of elements');
		end
end

HDR.bitpix = DataTypeSizes(HDR.datatype);

HDR.endian = 'l'; % coz this machine is little endian
% put the rest to zero
HDR.data_type = char(zeros(1, 10));
HDR.db_name = char(zeros(1, 18));
HDR.extents = 0;
HDR.session_error = 0;
HDR.regular = 'r';
HDR.hkey_un0 = 0;
HDR.dim_un0 = 0;
HDR.vox_offset = 0.0;
HDR.cal_max = 0.0;
HDR.cal_min = 0.0;
HDR.compressed = 0;
HDR.verified = 0;
HDR.glmin = min(AVW(:));
HDR.glmax = max(AVW(:));
HDR.descrip = char(zeros(1, 80));
HDR.aux_file = char(zeros(1, 24));
HDR.orient = 0;

HDR.origin(1) = 0; %HDR.dims(1)/2; HAH 26/07/2004
HDR.origin(2) = 0; %HDR.dims(2)/2; HAH 26/07/2004
HDR.origin(3) = 0; %HDR.dims(3)/2; HAH 26/07/2004

HDR.generated = char(zeros(1, 10));
HDR.scannum = char(zeros(1, 10));
HDR.patient_id = char(zeros(1, 10));
HDR.exp_date = char(zeros(1, 10));
HDR.exp_time = char(zeros(1, 10));
HDR.hist_un0 = char(zeros(1, 3));
HDR.views = 0;
HDR.vols_added = 0;
HDR.start_field = 0;
HDR.field_skip = 0;
HDR.omax = 0;
HDR.omin = 0;
HDR.smax = 0;
HDR.smin = 0;

save_avw_hdr(fname, HDR);
