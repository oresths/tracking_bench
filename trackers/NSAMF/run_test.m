% Used to test tracker
%
% coded by Li,Yang
%


%path to the videos (you'll be able to choose one with the GUI).
datasets={
struct('name','TB-50','basePath','~/benchmark/tb50'),...
struct('name','VOT14','basePath','E:\sever119\Documents\vot-toolkit-master\sequences'),...
struct('name','RGBD','basePath','E:\EvaluationSet'),...
struct('name','VOT15','basePath','D:\lab\WeiYun\codes\benchmark\vot15\sequences'),...
};

addpath('./utility');
addpath('./tracker');
addpath('./features');
addpath('./display');

%ask the user for the video, then call self with that video name.
[video, base_path, dataset] = choose_video(datasets);
%video = 'Bolt';
%base_path = '~/benchmarks/tb50/';
%dataset = 'TB-50';

%get image file names, initial state, and ground truth for evaluation
[img_files, pos, target_sz, ground_truth, video_path,datasetParam] = load_video_info(base_path, video,dataset);

%call tracker function
[rects, time] = nsamf(video_path, img_files, pos, target_sz,[]);

%calculate and show precision plot, as well as frames-per-second
if ~strcmp(dataset,'RGBD')
precisions = precision_plot(rects, ground_truth, video, 1);
end
fps = numel(img_files) / time;

fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', video, precisions(20), fps)
