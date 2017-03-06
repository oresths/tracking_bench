function run_vot
% ncc VOT integration example
% 
% This function is an example of tracker integration into the toolkit.
% The implemented tracker is a very simple NCC tracker that is also used as
% the baseline tracker for challenge entries.
%

% *************************************************************
% VOT: Always call exit command at the end to terminate Matlab!
% *************************************************************
 cleanup = onCleanup(@() exit() );

% *************************************************************
% VOT: Set random seed to a different value every time.
% *************************************************************
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock)));

% **********************************
% VOT: Get initialization data
% **********************************

addpath('~/codes/nsamf/utility');
addpath('~/codes/nsamf/tracker');
addpath('~/codes/nsamf/features');
% addpath('./display');

[handle, image, region] = vot('rectangle');
%get parameters
[model, param] = initNSAMF(imread(image), region([2,1])+region([4 3])/2, region([4 3]));

while true

    % **********************************
    % VOT: Get next frame
    % **********************************
    [handle, image] = handle.frame(handle);

    if isempty(image)
        break;
    end;
    
	% Perform a tracking step, obtain new region
    origimg = imread(image);
    if param.resize_image
        img = imresize(origimg,0.5);
    else
        img = origimg;
    end
    [model,param] = trackNSAMF(img,model,param);
    
    [model,param] = updateNSAMF(img,model,param);
    
    
    rect = double([model.pos([2,1]) - model.target_sz([2,1])/2, model.target_sz([2,1])]);
    
    % **********************************
    % VOT: Report position for frame
    % **********************************
    if param.resize_image
        rect = rect*2;
    end
    handle = handle.report(handle, rect);
    
end;

% **********************************
% VOT: Output the results
% **********************************
handle.quit(handle);

end

