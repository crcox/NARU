%% DE fMRI
%history of conceptual layout:
%modified Ajay Halai 17/12/2013
%orginally created by Ajay, modified by Rick Chen, 16/12/2013

%file prefix explanation: s: smoothing; w: normalisation; 
%r: coregistration; v: average of short and long echos; a:slice timing; u: realignment and unwarp

%% part 1
parrec_root = 'D:\MRI\SoundPicture\data\PARREC';

spm('fMRI');
[spmpath,~,~] = fileparts(which('spm'));
spm_jobman('initcfg');

% Subjects
subject = {...
    'MD106_050913',...
    'MD106_050913B',...
    'MRH026_201',...
    'MRH026_202',...
    'MRH026_203',...
    'MRH026_204',...
    'MRH026_205',...
    'MRH026_206',...
    'MRH026_207',...
    'MRH026_208',...
    'MRH026_209',...
    'MRH026_210',...
    'MRH026_211',...
    'MRH026_212',...
    'MRH026_213',...
    'MRH026_214',...
    'MRH026_215',...
    'MRH026_216',...
    'MRH026_217',...
    'MRH026_218',...
    'MRH026_219',...
    'MRH026_220',...
    'MRH026_221'};

%% Part 2
for i_subj = 1:length(subject);
    % extract PARREC to short and long echo, takes into account if you have
    % multiple runs - you need to name each run at beginning.
    subj_code = subject{i_subj};
    subject_path = fullfile(parrec_root, subj_code);
    subj_dir = ls_parrec(subject_path, 1);
    
    % Load scans from the experiment (in "runs" field)
    % N.B. This will be a small structured array, and a difficult one to
    % preallocate properly, so I will let it grow dynamically.
    for i=1:numel(subj_dir.runs);
        run_prefix = fullfile(subject_path, subj_dir.runs{i});
        [dynamics(:,i), image_meta(i)] = load_parrec(run_prefix,[],[],[],[],[]); %#ok<SAGROW>
        [dynamics(:,i).run] = deal(i); %#ok<SAGROW>
    end
    
    % Load fieldmapping scans (in "B0" field)
    B0_prefix = fullfile(subject_path, subj_dir.B0);
    [B0, B0_meta] = load_parrec(B0_prefix,[],[],[],[],[]);
    
    % does Fieldmap correction for each run
    AHfieldcorrection(root,subcode(s,:),allruns(i,:));
    
      % realignment and unwarp
      clear job
      
      phase_short= [root,'\',subcode(s,:),'\vdm5_scB0pha_short.nii'];
      phase_long= [root,'\',subcode(s,:),'\vdm5_scB0pha_long.nii'];% subject folder
      
      if n_run==1;
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      elseif n_run==2;
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_short\'];run2s = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder3, '^0.*\.img$'));
      tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n2,'_long\'];run2l = cellstr(spm_select('FPList', tmpcwdfolder4, '^0.*\.img$'));
      elseif n_run==3
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_short\'];run2s = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_short\'];run3s = cellstr(spm_select('FPList', tmpcwdfolder3, '^0.*\.img$'));
      tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder4, '^0.*\.img$'));          
      tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n2,'_long\'];run2l = cellstr(spm_select('FPList', tmpcwdfolder5, '^0.*\.img$'));
      tmpcwdfolder6 = [root,'\',subcode(s,:),'\',parrec_n3,'_long\'];run3l = cellstr(spm_select('FPList', tmpcwdfolder6, '^0.*\.img$'));
      elseif n_run==4
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_short\'];run2s = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_short\'];run3s = cellstr(spm_select('FPList', tmpcwdfolder3, '^0.*\.img$'));
      tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_short\'];run4s = cellstr(spm_select('FPList', tmpcwdfolder4, '^0.*\.img$'));          
      tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder5, '^0.*\.img$'));
      tmpcwdfolder6 = [root,'\',subcode(s,:),'\',parrec_n2,'_long\'];run2l = cellstr(spm_select('FPList', tmpcwdfolder6, '^0.*\.img$'));
      tmpcwdfolder7 = [root,'\',subcode(s,:),'\',parrec_n3,'_long\'];run3l = cellstr(spm_select('FPList', tmpcwdfolder7, '^0.*\.img$'));
      tmpcwdfolder8 = [root,'\',subcode(s,:),'\',parrec_n4,'_long\'];run4l = cellstr(spm_select('FPList', tmpcwdfolder8, '^0.*\.img$'));
      elseif n_run==5;
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_short\'];run2s = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_short\'];run3s = cellstr(spm_select('FPList', tmpcwdfolder3, '^0.*\.img$'));
      tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_short\'];run4s = cellstr(spm_select('FPList', tmpcwdfolder4, '^0.*\.img$'));          
      tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n5,'_short\'];run5s = cellstr(spm_select('FPList', tmpcwdfolder5, '^0.*\.img$'));
      tmpcwdfolder6 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder6, '^0.*\.img$'));
      tmpcwdfolder7 = [root,'\',subcode(s,:),'\',parrec_n2,'_long\'];run2l = cellstr(spm_select('FPList', tmpcwdfolder7, '^0.*\.img$'));
      tmpcwdfolder8 = [root,'\',subcode(s,:),'\',parrec_n3,'_long\'];run3l = cellstr(spm_select('FPList', tmpcwdfolder8, '^0.*\.img$'));
      tmpcwdfolder9 = [root,'\',subcode(s,:),'\',parrec_n4,'_long\'];run4l = cellstr(spm_select('FPList', tmpcwdfolder9, '^0.*\.img$'));
      tmpcwdfolder10 = [root,'\',subcode(s,:),'\',parrec_n5,'_long\'];run5l = cellstr(spm_select('FPList', tmpcwdfolder10, '^0.*\.img$'));
      elseif n_run==6;
      tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_short\'];run1s = cellstr(spm_select('FPList', tmpcwdfolder, '^0.*\.img$'));
      tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_short\'];run2s = cellstr(spm_select('FPList', tmpcwdfolder2, '^0.*\.img$'));
      tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_short\'];run3s = cellstr(spm_select('FPList', tmpcwdfolder3, '^0.*\.img$'));
      tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_short\'];run4s = cellstr(spm_select('FPList', tmpcwdfolder4, '^0.*\.img$'));          
      tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n5,'_short\'];run5s = cellstr(spm_select('FPList', tmpcwdfolder5, '^0.*\.img$'));
      tmpcwdfolder6 = [root,'\',subcode(s,:),'\',parrec_n6,'_short\'];run6s = cellstr(spm_select('FPList', tmpcwdfolder6, '^0.*\.img$'));
      tmpcwdfolder7 = [root,'\',subcode(s,:),'\',parrec_n1,'_long\'];run1l = cellstr(spm_select('FPList', tmpcwdfolder7, '^0.*\.img$'));
      tmpcwdfolder8 = [root,'\',subcode(s,:),'\',parrec_n2,'_long\'];run2l = cellstr(spm_select('FPList', tmpcwdfolder8, '^0.*\.img$'));
      tmpcwdfolder9 = [root,'\',subcode(s,:),'\',parrec_n3,'_long\'];run3l = cellstr(spm_select('FPList', tmpcwdfolder9, '^0.*\.img$'));
      tmpcwdfolder10 = [root,'\',subcode(s,:),'\',parrec_n4,'_long\'];run4l = cellstr(spm_select('FPList', tmpcwdfolder10, '^0.*\.img$'));
      tmpcwdfolder11 = [root,'\',subcode(s,:),'\',parrec_n5,'_long\'];run5l = cellstr(spm_select('FPList', tmpcwdfolder11, '^0.*\.img$'));
      tmpcwdfolder12 = [root,'\',subcode(s,:),'\',parrec_n6,'_long\'];run6l = cellstr(spm_select('FPList', tmpcwdfolder12, '^0.*\.img$'));
      end
                
    % realign fMRI dynamics - currently working in this script
    if n_run==1;
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l);
    elseif n_run==2;
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l);
    elseif n_run==3;
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l,run3s,run3l);
    elseif n_run==4; 
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l,run3s,run3l,run4s,run4l);
    elseif n_run==5; 
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l,run3s,run3l,run4s,run4l,run5s,run5l);
    elseif n_run==6;
    AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l,run3s,run3l,run4s,run4l,run5s,run5l,run6s,run6l);    
    end
    
    % Do slice timing correction if requested
    if slicetime=='Y';
    if n_run==1;
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1);
    elseif n_run==2;
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1,parrec_n2);
    elseif n_run==3;
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1,parrec_n2,parrec_n3);
    elseif n_run==4; 
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1,parrec_n2,parrec_n3,parrec_n4);
    elseif n_run==5; 
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1,parrec_n2,parrec_n3,parrec_n4,parrec_n5);
    elseif n_run==6;
    AHslicetimecorrection(n_run,root,subcode(s,:),parrec_n1,parrec_n2,parrec_n3,parrec_n4,parrec_n5,parrec_n6);    
    end
    end
       
    % combine short and long echo images, for all runs
    cd([root,'\',subcode(s,:),'\']);
    for i=1:n_run;
        mkdir([allruns(i,:),'_combined']);
        tmpcwdfolder = [root,'\',subcode(s,:),'\',allruns(i,:),'_short\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',allruns(i,:),'_long\'];
        if slicetime=='Y';
        urun1 = cellstr(spm_select('FPList', tmpcwdfolder, '^au.*\.img$'));
        urun2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^au.*\.img$'));
        elseif slicetime=='N';
        urun1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        urun2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        end
    
        cc=1;
        for r=1:n_scan % for each scan
            job{r}.spm.util.imcalc.input = {urun1{r}; urun2{r}};
            job{r}.spm.util.imcalc.output = sprintf('u%s.img',num2str(r,'%04i'));
            job{r}.spm.util.imcalc.outdir = {[root,'\',subcode(s,:),'\',allruns(i,:),'_combined\']};
            job{r}.spm.util.imcalc.expression = '(i1+i2)/2'; 
            job{r}.spm.util.imcalc.options.dmtx = 0;
            job{r}.spm.util.imcalc.options.mask = 0;
            job{r}.spm.util.imcalc.options.interp = 1;
            job{r}.spm.util.imcalc.options.dtype = 8;
        end
        spm_jobman('run',job);
    end
    clear job
    %coregister
    tmpT1 = [root,'\',subcode(s,:),'\T1.img,1'];
    cc=1;
    
    if n_run==1;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:}}';
    elseif n_run==2;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        run2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:},run2{:}}';
    elseif n_run==3;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_combined\'];
        tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        run2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        run3 = cellstr(spm_select('FPList', tmpcwdfolder3, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:},run2{:},run3{:}}';
    elseif n_run==4;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_combined\'];
        tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_combined\'];
        tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        run2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        run3 = cellstr(spm_select('FPList', tmpcwdfolder3, '^u.*\.img$'));
        run4 = cellstr(spm_select('FPList', tmpcwdfolder4, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:},run2{:},run3{:},run4{:}}';
    elseif n_run==5;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_combined\'];
        tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_combined\'];
        tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_combined\'];
        tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n5,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        run2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        run3 = cellstr(spm_select('FPList', tmpcwdfolder3, '^u.*\.img$'));
        run4 = cellstr(spm_select('FPList', tmpcwdfolder4, '^u.*\.img$'));
        run5 = cellstr(spm_select('FPList', tmpcwdfolder5, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:},run2{:},run3{:},run4{:},run5{:}}';
    elseif n_run==6;
        tmpcwdfolder = [root,'\',subcode(s,:),'\',parrec_n1,'_combined\'];
        tmpcwdfolder2 = [root,'\',subcode(s,:),'\',parrec_n2,'_combined\'];
        tmpcwdfolder3 = [root,'\',subcode(s,:),'\',parrec_n3,'_combined\'];
        tmpcwdfolder4 = [root,'\',subcode(s,:),'\',parrec_n4,'_combined\'];
        tmpcwdfolder5 = [root,'\',subcode(s,:),'\',parrec_n5,'_combined\'];
        tmpcwdfolder6 = [root,'\',subcode(s,:),'\',parrec_n6,'_combined\'];
        run1 = cellstr(spm_select('FPList', tmpcwdfolder, '^u.*\.img$'));
        run2 = cellstr(spm_select('FPList', tmpcwdfolder2, '^u.*\.img$'));
        run3 = cellstr(spm_select('FPList', tmpcwdfolder3, '^u.*\.img$'));
        run4 = cellstr(spm_select('FPList', tmpcwdfolder4, '^u.*\.img$'));
        run5 = cellstr(spm_select('FPList', tmpcwdfolder5, '^u.*\.img$'));
        run6 = cellstr(spm_select('FPList', tmpcwdfolder6, '^u.*\.img$'));
        job{cc}.spm.spatial.coreg.estimate.other = {run1{:},run2{:},run3{:},run4{:},run5{:},run6{:}}';    
    end
    
    job{cc}.spm.spatial.coreg.estimate.ref = {tmpT1}; % Specfiy T1, because of tilted brain, we try to adjust source to reference space
    job{cc}.spm.spatial.coreg.estimate.source = {[root,'\',subcode(s,:),'\',parrec_n1,'_short\meanu0001.img,1']};
%     job{cc}.spm.spatial.coreg.estimate.other = {}; %specified above when accounting for run
    job{cc}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    job{cc}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    job{cc}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    job{cc}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

    %run job list
    spm_jobman('run',job);
    cd ..
end