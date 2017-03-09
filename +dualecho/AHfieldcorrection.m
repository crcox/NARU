function AHfieldcorrection(root,subcode,parrecfile)
    magfile = [root,'\',subcode,'\B0x1.img,1'];
    phafile = [root,'\',subcode,'\B0x2.img,1'];
% convert B0 img hdr to nii
    job{1}.spm.util.cat.vols = {magfile};
    job{1}.spm.util.cat.name = 'B0mag.nii';
    job{1}.spm.util.cat.dtype = 4;
    job{2}.spm.util.cat.vols = {phafile};
    job{2}.spm.util.cat.name = 'B0pha.nii';
    job{2}.spm.util.cat.dtype = 4;
    spm_jobman('run',job);
    % calculate FIELDMAPS for short and long
    IP = FieldMap('Initialise');
    IP.et={5.19, 6.65};
    magfile = [root,'\',subcode,'\B0mag.nii'];
    phafile = [root,'\',subcode,'\B0pha.nii'];  
    %scale phase map to radians
    new_rad = scalepha2rad(phafile);% took spms scale function
    radfile = [root,'\',subcode,'\scB0pha.nii'];
    IP.P{1} = spm_vol(radfile);
    IP.P{2} = spm_vol(magfile);
    IP.tert =12;
    IP.epifm =1;
    IP.fm = FieldMap('CreateFieldMap',IP);
    FieldMap('Write',IP.P{1},IP.fm.fpm,'fpm_',64,'Smoothed phase map');
    [IP.vdm, IP.vdmP]=FieldMap('FM2VDM',IP);
    epi = [root,'\',subcode,'\',parrecfile,'_short\0001.img'];
    IP.epiP = spm_vol(epi);
    IP.vdmP = FieldMap('MatchVDM',IP);
    copyfile('vdm5_scB0pha.nii','vdm5_scB0pha_short.nii');
    
    clear IP
    IP = FieldMap('Initialise');
    IP.et={5.19, 6.65};
    magfile = [root,'\',subcode,'\B0mag.nii'];
    phafile = [root,'\',subcode,'\B0pha.nii'];  
    %scale phase map to radians
    new_rad = scalepha2rad(phafile);% took spms scale function
    radfile = [root,'\',subcode,'\scB0pha.nii'];
    IP.P{1} = spm_vol(radfile);
    IP.P{2} = spm_vol(magfile);
    IP.tert =35;
    IP.epifm =1;
    IP.fm = FieldMap('CreateFieldMap',IP);
    FieldMap('Write',IP.P{1},IP.fm.fpm,'fpm_',64,'Smoothed phase map');
    [IP.vdm, IP.vdmP]=FieldMap('FM2VDM',IP);
    epi = [root,'\',subcode,'\',parrecfile,'_long\0001.img'];
    IP.epiP = spm_vol(epi);
    IP.vdmP = FieldMap('MatchVDM',IP);
    copyfile('vdm5_scB0pha.nii','vdm5_scB0pha_long.nii');
    
    