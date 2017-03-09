function save_avw_img(fname, AVW, DATATYPE);

% SAVE_AVW_AVW(fname, AVW, DATATYPE)
%
% Saves an analyse img file.
%
% PARAMETERS:
% fname: If you want foo.img, this must be 'foo' or 'foo.img' or 'foo.hdr'.
% AVW: the matrix of intenisities.
% DATATYPE: the data type, the following values are supported:
% 2 = unsigned char (8 bits per voxel)
% 4 = signed short (16 bits per voxel)
% 8 = signed int (32 bits per voxel)
% 16 = float (32 bits per voxel)
% 64 = double (64 bits per voxel) (default if not given)

% remove extension if it exists
if ( (length(findstr(fname,'.hdr'))>0) | ...
	(length(findstr(fname,'.img')>0)) ),
  fname=fname(1:(length(fname)-4));
end

fnimg=strcat(fname,'.img');

fp=fopen(fnimg,'w');
dims = size(AVW);

%% DEFUNCT
%% flip y dimension to be consistent with MEDx
%% dat=flipdim(img,2);

dat = AVW(:);
%dat = reshape(dat,prod(dims),1);

% DATATYPE2 is the string that is used for writing the data to disk
% so it is 'uchar', 'short'... based on the integer values from the
% ANALYZE specification
switch DATATYPE
  case 2
    DATATYPE2='uchar';
  case 4
    DATATYPE2='short';
  case 8
    DATATYPE2='int32';
  case 16
    DATATYPE2='float';
  case 64
    DATATYPE2='double';
end;

fwrite(fp, dat, DATATYPE2);
fclose(fp);

clear dat;
