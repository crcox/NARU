function s = ls_parrec(path, unpack)
% LS_PARREC List and categorize PAR/REC prefixes in a directory.
%
% Examples:
% s = ls_parrec(path) Check the directory indicated by the path for files
%     with extension .PAR, and generate a structured output that groups
%     files by type.
% s = ls_parrec(path, unpack) Unpack is a logical toggle. If true (the
%     default) categories with a single element will be "unpacked", meaning
%     that they will stored as a string rather than a cellstr within the
%     structure.
%
% <Chris Cox 20/03/2017>
    if nargin < 2
        unpack = 1;
    end
    d = dir(path);
    fn = {d(~[d.isdir]).name};
    z_par = cellfun(@(x) strcmpi('.par', x(end-3:end)), fn, 'unif', 1);
    [~,f,~] = cellfun(@(x) fileparts(x), fn(z_par), 'unif', 0);
    
    z_RUN = ~cellfun('isempty', regexp(f, '_WIP_RUN_[0-9]+_DE_SENSE_[0-9]+_[0-9]+'));
    z_RS = ~cellfun('isempty', regexp(f, '_WIP_RS_DE_SENSE_[0-9]+_[0-9]+'));
    z_Practice = ~cellfun('isempty', regexp(f, '_WIP_PRACTICE_[0-9]+_SENSE_[0-9]+_[0-9]+'));
    z_B0 = ~cellfun('isempty', regexp(f, '_WIP_Anna_B0_mapping_CLEAR_[0-9]+_[0-9]+'));
    z_T1W_IR = ~cellfun('isempty', regexp(f, '_T1W_IR_[0-9]+_SENSE_[0-9]+_[0-9]+'));
    z_Survey = ~cellfun('isempty', regexp(f, '_Survey_[0-9]+_[0-9]+'));
    z_MPR_RPS = ~cellfun('isempty', regexp(f, '_MPR-RPS_[0-9]+_[0-9]+'));
    
    s = struct(...
        'runs', {sort(f(z_RUN))}, ...
        'RS', {sort(f(z_RS))}, ...
        'practice', {sort(f(z_Practice))}, ...
        'B0', {sort(f(z_B0))}, ...
        'T1', {sort(f(z_T1W_IR))}, ...
        'survey', {sort(f(z_Survey))}, ...
        'MPR_RPS', {sort(f(z_MPR_RPS))});
    
    % Unpack cell arrays with only one element.
    if unpack
        fn = fieldnames(s);
        for i = 1:length(fn)
            if numel(s.(fn{i})) == 1
                s.(fn{i}) = s.(fn{i}){1};
            end
        end 
    end
end
    
    