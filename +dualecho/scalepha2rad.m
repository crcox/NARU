function [new_rad] = scalepha2rad(phafile)
%scale to radians
	V=spm_vol(phafile);
    vol=spm_read_vols(V);
    mn=min(vol(:));
    mx=max(vol(:));
    vol=-pi+(vol-mn)*2*pi/(mx-mn);
    V.dt(1)=4;   
    new_rad = FieldMap('Write',V,vol,'sc',V.dt(1),V.descrip);