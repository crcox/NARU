function AHrealign_multruns(n_run,phase_short,phase_long,run1s,run1l,run2s,run2l,run3s,run3l,run4s,run4l,run5s,run5l)
    
%set all values
    for cc=1:2;
    job{cc}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    job{cc}.spm.spatial.realignunwarp.eoptions.sep = 4;
    job{cc}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    job{cc}.spm.spatial.realignunwarp.eoptions.rtm = 0; % realign to mean == 1; realign to first == 0
    job{cc}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    job{cc}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    job{cc}.spm.spatial.realignunwarp.eoptions.weight = '';
    job{cc}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    job{cc}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    job{cc}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    job{cc}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    job{cc}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    job{cc}.spm.spatial.realignunwarp.uweoptions.sot = [];
    job{cc}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    job{cc}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    job{cc}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    job{cc}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    job{cc}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    job{cc}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    job{cc}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    job{cc}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    job{cc}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    end

    %adjust if multiple runs
    
    if n_run==1;
    cc=1;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1s;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_short};
    cc=2;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1l;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_long};
    elseif n_run==2;
    cc=1;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1s;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2s;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_short};    
    cc=2;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1l;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2l;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_long};
    elseif n_run==3;
    cc=1;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1s;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2s;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_short}; 
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3s;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_short};    
    cc=2;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1l;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2l;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3l;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_long};   
    elseif n_run==4;
    cc=1;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1s;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2s;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3s;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(4).scans = run4s;
    job{cc}.spm.spatial.realignunwarp.data(4).pmscan = {phase_short};
    cc=2;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1l;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2l;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3l;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(4).scans = run4l;
    job{cc}.spm.spatial.realignunwarp.data(4).pmscan = {phase_long};
    elseif n_run==5;
    cc=1;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1s;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2s;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3s;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(4).scans = run4s;
    job{cc}.spm.spatial.realignunwarp.data(4).pmscan = {phase_short};
    job{cc}.spm.spatial.realignunwarp.data(5).scans = run5s;
    job{cc}.spm.spatial.realignunwarp.data(5).pmscan = {phase_short}; 
    cc=2;
    job{cc}.spm.spatial.realignunwarp.data(1).scans = run1l;
    job{cc}.spm.spatial.realignunwarp.data(1).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(2).scans = run2l;
    job{cc}.spm.spatial.realignunwarp.data(2).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(3).scans = run3l;
    job{cc}.spm.spatial.realignunwarp.data(3).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(4).scans = run4l;
    job{cc}.spm.spatial.realignunwarp.data(4).pmscan = {phase_long};
    job{cc}.spm.spatial.realignunwarp.data(5).scans = run5l;
    job{cc}.spm.spatial.realignunwarp.data(5).pmscan = {phase_long};
    end
    
        % print movement graphs
    cc=cc+1;
    job{cc}.spm.util.print.fname = 'movement';
    job{cc}.spm.util.print.fig.figname = 'Graphics';
    job{cc}.spm.util.print.opts.opt = {'-djpeg'};
    job{cc}.spm.util.print.opts.append = false;
    job{cc}.spm.util.print.opts.ext = '.jpg';
    
    spm_jobman('run',job);
    
    
    
    
    
    
    
    
    
    
    