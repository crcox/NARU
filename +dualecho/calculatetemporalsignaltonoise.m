function [temporalsnimage] = calculatetemporalsignaltonoise(uigetfile('*.*','browse to first image in directory of timepoints'))
% script to claculate temporal signal to noise for each slice 
% tsr defined    by dividing the mean of a time series by its standard deviation      following murphy et al 2007

numbtimepoints = input('enter number of timepoints');

x = input('enter number pixels x');
y = input('enter  number pixels y');
slicen = input('enter number of image slices');
outdim = input('enter pixel dimension x');
outdim(2) = input('enter pixel dimension y');
outdim(3) = input('enter pixel dimension z');
[fname_b,pname_b] = uigetfile('*.*','browse to first image in directory of timepoints');

%dynimage4d = single(zeros(x,y,numbtimepoints,slicen));
dynimage4d = zeros(x,y,numbtimepoints,slicen);

sumimage = zeros(x,y,slicen);
for i=1:numbtimepoints     % open images and create 4dfile
     numbext = num2str(i,'%04.0f');
filename_reg = [pname_b, 'r' ,numbext,'.hdr'];
[dynimage,pixdim_a,dtype_a] = readanalyze(filename_reg);
%dynimage4d(:,:,i,:) = single(dynimage);
dynimage4d(:,:,i,:) = dynimage;
sumimage = sumimage + dynimage;
end
meanimage = sumimage/numbtimepoints;
stddevimage = zeros(x,y,slicen); 
for slicenumb = 1:slicen 
for i = 1:x
    for j = 1:y
        stddevimage(i,j,slicenumb) = std(dynimage4d(i,j,:,slicenumb));
    end
end
end
%savestringstddev = [pname_b,'stddev'];
%save_avw(savestringstddev, stddevimage,16,outdim);
temporalsnimage = meanimage./stddevimage;
savestringtemporalsn = [pname_b,'temporalsn'];
save_avw(savestringtemporalsn, temporalsnimage,16,outdim);


% clear all
