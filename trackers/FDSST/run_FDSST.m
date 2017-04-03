function results=run_FDSST(seq, res_path, bSaveImage, parameters)

% clear all;

% %choose the path to the videos (you'll be able to choose one with the GUI)
% base_path = 'sequences/';

%parameters according to the paper
params.padding = 1.0;       %2.0            % extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output
params.scale_sigma_factor = 1/16;       % standard deviation for the desired scale filter output
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.interp_factor = 0.012;	%0.025;		% tracking model learning rate (denoted "eta" in the paper)
params.num_compressed_dim = 18; %18        % the dimensionality of the compressed features
params.refinement_iterations = 3;%1;       % number of iterations used to refine the resulting position in a frame
params.translation_model_max_area = inf;% maximum area of the translation model
params.interpolate_response = 1;        % interpolation method for the translation scores
params.resize_factor = 1;               % initial resize

params.number_of_scales = 17;           % number of scale levels
params.number_of_interp_scales = 33;    % number of scale levels after interpolation
params.scale_model_factor = 1.0;        % relative size of the scale sample
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;      % the maximum size of scale examples
params.s_num_compressed_dim = 'MAX';    % number of compressed scale feature dimensions

params.visualization = 0;

% %ask the user for the video
% video_path = choose_video(base_path);
% if isempty(video_path), return, end  %user cancelled
% [img_files, pos, target_sz, ground_truth, video_path] = ...
% 	load_video_info(video_path);

target_sz = seq.init_rect(1,[4,3]);
pos = seq.init_rect(1,[2,1]);% + floor(target_sz/2);
img_files = seq.s_frames;
video_path = [];

params.init_pos = floor(pos) + floor(target_sz/2);
params.wsize = floor(target_sz);
params.s_frames = img_files;
params.video_path = video_path;

results = fDSST(params);

positions = results.res;
fps = results.fps;

%return results to benchmark, in a workspace variable
rects = [positions(:,1), positions(:,2)];
rects(:,3) = target_sz(2);
rects(:,4) = target_sz(1);
disp(['fps: ' num2str(fps)])
results.type = 'rect';
results.res = rects;
results.fps = fps;

% % calculate precisions
% [distance_precision, PASCAL_precision, average_center_location_error] = ...
%     compute_performance_measures(positions, ground_truth);
% 
% fprintf('Center Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
%     average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);