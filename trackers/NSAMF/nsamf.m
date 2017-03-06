% NSAMF tracker
% coded by Li, Yang, 2015


function [rects, time] = nsamf(video_path, img_files, pos, target_sz,datasetParam)

%get parameters
firstImg = imread([video_path img_files{1}]);

[model, param] = initNSAMF(firstImg, pos, target_sz);

totalFames = numel(img_files);

rects = zeros(totalFames,4);
rects(1,:) = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
if isempty(datasetParam)
    param = displayManager(firstImg,rects(1,:),model,param);
end

tic
for frame=2:numel(img_files)
    origimg = imread([video_path img_files{frame}]);
    if param.resize_image
        img = imresize(origimg,0.5);
    else
        img = origimg;
    end
    [model,param] = trackNSAMF(img,model,param);
    
    [model,param] = updateNSAMF(img,model,param);
    
    
    rect = [model.pos([2,1]) - model.target_sz([2,1])/2, model.target_sz([2,1])];
    if param.resize_image
        rect = rect*2;
    end
    rects(frame,:) = rect;
    if isempty(datasetParam)
        param = displayManager(origimg,rect,model,param);
    end
end
% if resize_image,
%     rect = rect *2;
% end
time = toc;

end