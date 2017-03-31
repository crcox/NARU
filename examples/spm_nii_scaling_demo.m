%% Reading and writing integer data to NIFTI with SPM
% Imaging data are often written to disk as integers to save on space.
% However, it is clear that integers take on a relatively constrained set
% of values relative to floating-point numbers. The utility of the integer
% storage format is maximized through scaling. In this demo, I walk through
% the read/write mechanism of spm_vol/spm_read_vols as it pertains to
% scaling integer data.

%% Define Structure Skeleton
hdr(1).fname = 'C:\Users\mbmhscc4\MATLAB\test.nii';
hdr(1).dim = [4,4,4];
hdr(1).dt = [spm_type('uint16'),0];
hdr(1).mat = eye(4)*3;
hdr(1).mat(:,4) = [-7.5,-7.5,-7.5,1];
hdr(1).mat = hdr(1).mat;
hdr(1).mat_intent = 'align';
hdr(1).mat0 = eye(4)*3;
hdr(1).mat0(:,4) = [-7.5,-7.5,-7.5,1];
hdr(1).mat0 = hdr(1).mat0;
hdr(1).mat0_intent = 'scanner';
hdr(1).n = [];
hdr(1).descrip = '';
hdr(1).private = [];

%% A note before beginning
% In the later part of this demo, I "discover" the format of the data
% written to disk. In fact, this is no surprise. Notice that in the
% structure-skeleton I defined the data type to uint16. This is the same
% format as the PAR/REC output, so nothing will be lost by storing the
% source data this way. The data will just be easier to read into
% Matlab/SPM. When saving results, that format should be float or double,
% and in those cases scaling will not be required.

%% Apply appropriate scaling
% SPM will subtract the intercept (0) and divide by the slope (100), in
% that order, when writing integers to disk. The slope and intercept are
% stored in hdr.pinfo([1,2]). In this dataset, voxels have a value of
% either 0 or 100, and so scaling by 100 will store the integer values 0
% and 1, respectively. When SPM reads this dataset back in, it will
% multiply by 100 and add 0 (in that order). This scaling factor will allow
% the data to be read and written without losing any information.
hdr(1).pinfo = [100,0,352]';
d = zeros(4,4,4);
d(2:3,2:3,2:3) = ones(2,2,2)*100;
x = spm_write_vol(hdr, d);
[y, xyz] = spm_read_vols(x);
disp([d(:),y(:)]');

%% Force bad scaling that will return the wrong values
% Given what I asserted above, we might expect a scaling factor of 200 to
% behave strangely... dividing by 100/200 = 0.5. But 0.5 cannot be stored
% as an integer, so rounding happens when storing to disk. Then, SPM will
% read the data back and, critially, *will not account for the rounding
% error*.

hdr(1).pinfo = [200,0,352]';
d = zeros(4,4,4);
d(2:3,2:3,2:3) = ones(2,2,2)*100;
x = spm_write_vol(hdr, d);
[y, xyz] = spm_read_vols(x);
disp([d(:),y(:)]');

%% Force bad scaling that will return all zeros
% Why does this one produce all zeros and the previous one a wrong scaling?
% Because 100/200 is exactly 0.5 and int16(0.5) = 1 (rounding *up*),
% while and 100/300 is 0.333 and int16(0.333) = 0 (rounding *down*).

hdr(1).pinfo = [300,0,352]';
d = zeros(4,4,4);
d(2:3,2:3,2:3) = ones(2,2,2)*100;
x = spm_write_vol(hdr, d);
[y, xyz] = spm_read_vols(x);
disp([d(:),y(:)]');

%% Force bad scaling that will return all 100
% This implies that unsigned integers are being written to disk.

hdr(1).pinfo = [100,100,352]';
d = zeros(4,4,4);
d(2:3,2:3,2:3) = ones(2,2,2)*100;
x = spm_write_vol(hdr, d);
[y, xyz] = spm_read_vols(x);
disp([d(:),y(:)]');

% Note that:
a = [0,0];
a(1) = (double(int16((100 - 200) / 100)) * 100) + 200;
a(2) = (double(uint16((100 - 200) / 100)) * 100) + 200;
disp(a);


%% Force bad scaling that will return all 65.535
% This implies that specifically 16-bit unsigned integers are written to
% disk.

hdr(1).pinfo = [1e-3,0,352]';
d = zeros(4,4,4);
d(2:3,2:3,2:3) = ones(2,2,2)*100;
x = spm_write_vol(hdr, d);
[y, xyz] = spm_read_vols(x);
disp([d(:),y(:)]');

% Note that:
max_uint16 = double(uint16(inf));
a = [0,0,0];
a(1) = 100e3;
a(2) = max_uint16;
a(3) = max_uint16 * 1e-3;
fprintf('\t%d', a(1:2)); fprintf('\t%.4f\n', a(3));

%% Theory of scaling?
% This is not from a text book or an authority. I am just putting some
% ideas together. Basically, the data should be scaled to occupy a range
% between 0 and 65535 before rounding off to integers. Hopefully, this is
% enough fidelity to capture most of the meaningful variation in the
% signal. And realy, it should. Imaging you are working with pct signal
% change. And lets say the range of signal change is between -500 and 500.
% Spaning that space in 65535 steps means you can represent changes of
% 0.015 pct signal change. If you assume a smaller range of signal change,
% the fidelity of the integer representation effectively increases. The
% motivation for storing data on disk as integers is that this is probably
% high enough fidelity, and it allows datasets to be a fraction of the size
% they would be if storing 32 or 64 bit floats.
%
% This raises an interesting technical question. If the logic above is
% true, then artifactual spikes in the signal comming off the scanner
% effectively destroy the fidelity of the source data. I am sure this is
% accounted for, but it would be interesting to know how the data are
% censored before that first data file is written.