%% DE fMRI
%history of conceptual layout:
%modified Ajay Halai 17/12/2013
%orginally created by Ajay, modified by Rick Chen, 16/12/2013

%file prefix explanation: s: smoothing; w: normalisation; 
%r: coregistration; v: average of short and long echos; a:slice timing; u: realignment and unwarp

spm('fMRI');
spm_jobman('initcfg');

root = uigetdir('','Please select folder containing all subject folders');
[spmpath,~,~] = fileparts(which('spm'));

