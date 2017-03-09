function save_avw_hdr(fname, HDR)

% SAVE_AVW_HDR(fname, HDR) 
%
% Saves the given analyse header structure to the file "fname.hdr"
%
% PARAMETERS:
% 	fname ['string']: the filename, if you want 'foo.hdr' this needs to be 'foo' or 'foo.hdr' or 'foo.img'
% 	HDR [1] (structure): the header structure, for a list of fields, refer to avw_fields.txt

% remove extension if it exists
if ( (length(findstr(fname,'.hdr'))>0) | ...
	(length(findstr(fname,'.img')>0)) ),
	fname=fname(1:(length(fname)-4));
end

fname = strcat(fname, '.hdr');

ndims = length(HDR.dims);

if (length(HDR.dims) < 3)
  HDR.dims(3) = 3;
end

if (length(HDR.dims) < 4)
  HDR.dims(4) = 1;
end

HDR.dims(2:5) = HDR.dims;
HDR.dims(1) = ndims;
HDR.dims(6:8) = 0;

sizeof_hdr = 348;
fid = fopen(fname, 'wb');
fwrite(fid, sizeof_hdr, 'int32');

fwrite(fid, HDR.data_type, 'char');
fwrite(fid, HDR.db_name, 'char');
fwrite(fid, HDR.extents, 'int32');
fwrite(fid, HDR.session_error, 'int16');
fwrite(fid, HDR.regular, 'char');
fwrite(fid, HDR.hkey_un0, 'char');
fwrite(fid, HDR.dims, 'int16');

dummy = int16(zeros(7, 1));
fwrite(fid, dummy, 'int16');

fwrite(fid, HDR.datatype, 'int16');  
fwrite(fid, HDR.bitpix, 'int16');
fwrite(fid, HDR.dim_un0, 'int16');

dummy = 0;
% first dimension os always 0
fwrite(fid, dummy, 'float');

fwrite(fid, HDR.scales, 'float');
% pad out the remaining scales with 0
dummy = zeros(7 - length(HDR.scales), 1);
fwrite(fid, dummy, 'float');

fwrite(fid, HDR.vox_offset, 'float');

% funused1..3
dummy = single(zeros(3, 1));
fwrite(fid, dummy, 'float');

fwrite(fid, HDR.cal_max, 'float');
fwrite(fid, HDR.cal_min, 'float');
fwrite(fid, HDR.compressed, 'int32');
fwrite(fid, HDR.verified, 'int32');
fwrite(fid, HDR.glmax, 'int32');
fwrite(fid, HDR.glmin, 'int32');
fwrite(fid, HDR.descrip, 'char');
fwrite(fid, HDR.aux_file, 'char');
fwrite(fid, HDR.orient, 'char');

fwrite(fid, HDR.origin(1), 'int16');
fwrite(fid, HDR.origin(2), 'int16');
fwrite(fid, HDR.origin(3), 'int16');

dummy = int16(zeros(2, 1));
fwrite(fid, dummy, 'int16');

fwrite(fid, HDR.generated, 'char');
fwrite(fid, HDR.scannum, 'char');
fwrite(fid, HDR.patient_id, 'char');
fwrite(fid, HDR.exp_date, 'char');
fwrite(fid, HDR.exp_time, 'char');
fwrite(fid, HDR.hist_un0, 'char');
fwrite(fid, HDR.views, 'int32');
fwrite(fid, HDR.vols_added, 'int32');
fwrite(fid, HDR.start_field, 'int32');
fwrite(fid, HDR.field_skip, 'int32');
fwrite(fid, HDR.omax, 'int32');
fwrite(fid, HDR.omin, 'int32');
fwrite(fid, HDR.smax, 'int32');
fwrite(fid, HDR.smin, 'int32');
fclose(fid);
