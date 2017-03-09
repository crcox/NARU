function naru_slicetimecorrect(scans, runs)
    p = inputparser();
    
    addRequired(p, 'scans', @ispositiveinteger);
    addRequired(p, 'runs', @ispositiveinteger);
    parse(p, scans, runs);
    
    n_scan = p.Results.scans;
    n_run = p.Results.runs;
end