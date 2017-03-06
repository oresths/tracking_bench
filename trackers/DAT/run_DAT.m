function results = run_DAT(seq, res_path, bSaveImage)

% Load default settings
cfg = default_parameters_dat();

% Tracking
frames = seq.startFrame:seq.endFrame;
times = zeros(seq.len, 1);
rects = zeros(seq.len, size(seq.init_rect,2));
for frame = frames
  I = imread(seq.s_frames{frame});
  
  ttrack = tic;
  if frame == 1
    [state, location] = tracker_dat_initialize(I, seq.init_rect, cfg); 
  else
    [state, location] = tracker_dat_update(state, I, cfg);
  end
  times(frame) = toc(ttrack);
  
  rects(frame, :) = location;
  
%   % Visualization
%   figure(1), clf
%   imshow(I)
%   rectangle('Position', location, 'EdgeColor', 'b', 'LineWidth', 2);
%   drawnow
end

results.res = rects;
results.type='rect';
results.fps=1/mean(times);

disp(results.fps)
