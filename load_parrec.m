function load_parrec(filename)
% LOAD_PARREC Parse Par/Rec files into matrixes.
[pr_path,pr_name,~] = fileparts(filename);
pr_fullfile = [fullfile(pr_path,pr_name),'.PAR'];

fid = fopen(pr_fullfile);
data_description = textscan(fid,'%s','Delimiter','\n');
data_description = data_description{1};
fclose(fid);

% Find the beginning of the embedded image information
image_meta = struct( ...
    'Patient_name', [], ...
    'Examination_name', [], ...
    'Protocol_name', [], ...
    'Examination_date/time', [], ...
    'Series_Type', [], ...
    'Acquisition_nr', [], ...
    'Reconstruction_nr', [], ...                 
    'Scan_Duration_[sec]', [], ...              
    'Max._number_of_cardiac_phases', [], ...   
    'Max._number_of_echoes', [], ...          
    'Max._number_of_slices/locations', [], ...
    'Max._number_of_dynamics', [], ...            
    'Max._number_of_mixes', [], ...               
    'Patient_position', [], ...                   
    'Preparation_direction', [], ...              
    'Technique', [], ...                          
    'Scan_resolution', [], ...  (x,_y)            
    'Scan_mode', [], ...                          
    'Repetition_time_[ms]', [], ...               
    'FOV_(ap,fh,rl)_[mm]', [], ...                
    'Water_Fat_shift_[pixels]', [], ...           
    'Angulation_midslice(ap,fh,rl)[degr]', [], ...
    'Off_Centre_midslice(ap,fh,rl)_[mm]', [], ... 
    'Flow_compensation_<0=no_1=yes>_?', [], ...   
    'Presaturation', [], ...     <0=no_1=yes>_?   
    'Phase_encoding_velocity_[cm/sec]', [], ...   
    'MTC', [], ...               <0=no_1=yes>_?   
    'SPIR', [], ...              <0=no_1=yes>_?   
    'EPI_factor', [], ...        <0,1=no_EPI>     
    'Dynamic_scan', [], ...      <0=no_1=yes>_?   
    'Diffusion', [], ...         <0=no_1=yes>_?   
    'Diffusion_echo_time_[ms]', [], ...           
    'Max._number_of_diffusion_values', [], ...    
    'Max._number_of_gradient_orients', [], ...    
    'Number_of_label_types', [] ...   <0=no_ASL> 
);
meta_names = fieldnames(image_meta);

gen_info_beg = strfind(data_description, '= GENERAL INFORMATION =') + 1;
gen_info_end = strfind(data_description, '= PIXEL VALUES =') - 1;
gen_info = data_description(gen_info_beg, gen_info_end);
for i = 1:length(meta_names)
    tmp = strfind(gen_info, strrep(metanames{i},'_',' '));
    row_id = find(~cellfun('isempty', gen_info));
    row_str = gen_info{row_id};
    delim_pos = strfind(row_str, ':');
    row_val = strtrim(row_str((delim_pos(1)+1):end));
    row_num = str2num(row_val);
    if isempty(row_num);
        gen_info.(meta_names{i})
    
end
% === IMAGE INFORMATION DEFINITION =============================================
%  The rest of this file contains ONE line per image, this line contains the following information:
image_info = struct(...
    'slice_number',                 [], ... (integer)
    'echo_number',                  [], ... (integer)
    'dynamic_scan_number',          [], ... (integer)
    'cardiac phase number',         [], ... (integer)
    'image_type_mr',                [], ... (integer)
    'scanning_sequence',            [], ... (integer)
    'index_in_REC_file_(in_images)',[], ... (integer)
    'image_pixel_size_(in_bits)', [], ...               (integer)
    'scan_percentage', [], ...                          (integer)
    'recon_resolution_(x_y)', [], ...                   (2*integer)
    'rescale_intercept', [], ...                        (float)
    'rescale_slope', [], ...                            (float)
    'scale_slope', [], ...                              (float)
    'window_center', [], ...                            (integer)
    'window_width', [], ...                             (integer)
    'image_angulation_(ap,fh,rl_in_degrees_)', [], ...  (3*float)
    'image_offcentre_(ap,fh,rl_in_mm_)', [], ...        (3*float)
    'slice_thickness_(in_mm_)', [], ...                 (float)
    'slice_gap_(in_mm_)', [], ...                       (float)
    'image_display_orientation', [], ...                (integer)
    'slice_orientation_(', [], ... TRA/SAG/COR_)        (integer)
    'fmri_status_indication', [], ...                   (integer)
    'image_type_ed_es', [], ...  (end_diast/end_syst)   (integer)
    'pixel_spacing_(x,y)_(in_mm)', [], ...              (2*float)
    'echo_time', [], ...                                (float)
    'dyn_scan_begin_time', [], ...                      (float)
    'trigger_time', [], ...                             (float)
    'diffusion_b_factor', [], ...                       (float)
    'number_of_averages', [], ...                       (integer)
    'image_flip_angle_(in_degrees)', [], ...            (float)
    'cardiac_frequency', [], ...   (bpm)                (integer)
    'minimum_RR-interval_(in_ms)', [], ...              (integer)
    'maximum_RR-interval_(in_ms)', [], ...              (integer)
    'TURBO_factor', [], ...  <0=no_turbo>               (integer)
    'Inversion_delay_(in_ms)', [], ...                  (float)
    'diffusion_b', [], ... value_number    (imagekey!)  (integer)
    'gradient_orientation_number', [], ... (imagekey!)  (integer)
    'contrast_type', [], ...                            (string)
    'diffusion_anisotropy_type', [], ...                (string)
    'diffusion_(ap,_fh,_rl)', [], ...                   (3*float)
    'label_type_(ASL)', [], ...            (imagekey!)  (integer)
tmp = strfind(data_description, '= IMAGE INFORMATION =');
row_id = find(~cellfun('isempty', data_description));


a = s{300,1};
a = textscan(a,'%n','Delimiter','\n');
a=a{1};
slicen=s{22,1};
gradient=s{23,1};
slicen=str2num(slicen(end-2:end));
gradient=str2num(gradient(end-2:end));

find(~cellfun('isempty', s))
x = a(10);
y = a(11);
outdim = a(29);
outdim(2) = a(30);
outdim(3) = a(23);
gradientn = 2 * gradient;
scalingfactor = a(14);
              
mkdir (pname_a,[fname1st_a,'_short']); 
mkdir (pname_a,[fname1st_a,'_long']); 
workspace_path = [pname_a,fname1st_a,'_short\workspace'];
save(workspace_path);

karls_rescalefactor = 1000;

gradientnhalf = round(gradientn/2);
num_elements = x * y * slicen * gradientn;
num_images = gradientn * slicen;

tic;
t=now;
fprintf('Started %s\n', datestr(t, 'dd mmmm yyyy, HH:MM:SS.FFF'));


fid = fopen(funcstring); %open data stream for rec file
img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16
dual4d = reshape(img,[x y slicen gradientn]);

%seperate TE 12 images
te_short_4d = zeros(x,y,slicen,gradientnhalf);
te_short_index = 1;
for i = 1:2:gradientn
te_short_4d(:,:,:,te_short_index) = dual4d(:,:,:,i);
te_short_4d(:,:,:,te_short_index) = (te_short_4d(:,:,:,te_short_index)/ scalingfactor) / karls_rescalefactor;
te_short_index = te_short_index + 1;
end

%seperate TE 35 images
te_long_4d = zeros(x,y,slicen,gradientnhalf);
te_long_index = 1;
for i = 2:2:gradientn
te_long_4d(:,:,:,te_long_index) = dual4d(:,:,:,i);
te_long_4d(:,:,:,te_long_index) =(te_long_4d(:,:,:,te_long_index)/ scalingfactor) / karls_rescalefactor;
te_long_index = te_long_index + 1;
end
