function runTracker
% RUN_TRACKER  is the external function of the tracker - does initialization and calls trackerMain

    %% Read params.txt
%     run matconvnet/matlab/vl_setupnn.m
    params = readParams('params.txt');
	%% load video info
    datasets={struct('name','TB-50','basePath','D:\Kernel Corralation Filter\Data\'),...
        struct('name','VOT15','basePath','C:\Users\oz16265\Local Documents\vot2016')...
        struct('name','UAV123','basePath','C:\Users\oz16265\Local Documents\Dataset_UAV123\UAV123\data_seq\UAV123')
        };

    %ask the user for the video, then call self with that video name.
%     [sequence, base_path, dataset] = choose_video(datasets);
    sequence = 'cyclist0';
    base_path = 'C:\Users\oz16265\Local Documents\Dataset_UAV123\UAV123\data_seq\UAV123\';
    dataset = 'UAV123';
    
	sequence_path = [base_path,sequence,'\'];
%     img_path = [sequence_path 'img\'];
    img_path = [sequence_path];
    %get image file names, initial state, and ground truth for evaluation
    [img_files, pos, target_sz, ground_truth, video_path,datasetParam] = load_video_info(base_path, sequence,dataset);

    %%
    im = imread([img_path img_files{1}]);
    % is a grayscale sequence ?
    if(size(im,3)==1)
        params.grayscale_sequence = true;
    end

    params.img_files = img_files;
    params.img_path = img_path;


    % init_pos is the centre of the initial bounding box
    params.init_pos = pos;
    params.target_sz = round(target_sz);
    [params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(im, params);
	if params.visualization
		params.videoPlayer = vision.VideoPlayer('Position', [100 100 [size(im,2), size(im,1)]+30]);
	end
    % in runTracker we do not output anything
	params.fout = -1;
	% start the actual tracking
  
	result = trackerMain(params, im, bg_area, fg_area, area_resize_factor);

    precisions = precision_plot(result.res, ground_truth, sequence, 1);
    
    fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', sequence, precisions(20), result.fps)

end
