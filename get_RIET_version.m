function version = get_RIET_version(partext)
% GET_RIET_VERSION Parse PAR for Research Image Export Tool version.
    selection_beg = rowfind(partext, '= DATA DESCRIPTION FILE =') + 1;
    selection_end = rowfind(partext, '= GENERAL INFORMATION =') - 1;
    parheadertext = partext(selection_beg:selection_end);
    index = regexp(parheadertext, 'V[0-9]+\.[0-2]+$');
    z = ~cellfun('isempty', index);
    if nnz(z) > 1;
      error('load_parrec:get_REIT_version:tooManyMatches', 'Could not identify version number (too many strings match regexp).');
    elseif nnz(z) == 0
      error('load_parrec:get_REIT_version:noMatch', 'Could not identify version number (no strings match regexp).');
    end
    i = index{z};
    version = parheadertext{z}(i:end);
end
