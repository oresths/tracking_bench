dataType = 'png';    
base_path = 'E:/EvaluationSet/';
outputpath = './results/';

if ispc(), base_path = strrep(base_path, '\', '/'); end
	if base_path(end) ~= '/', base_path(end+1) = '/'; end
	
	%list all sub-folders
	contents = dir(base_path);
	names = {};
	for k = 1:numel(contents),
		name = contents(k).name;
		if isdir([base_path name]) && ~any(strcmp(name, {'.', '..'})),
			names{end+1} = name;  %#ok
		end
    end
    
    
    
    	%path to the videos (you'll be able to choose one with the GUI).
	base_path ='E:\EvaluationSet';%'E:\ValidationSet';%
	%default settings


    
for k = 1:numel(names),

    video=names{k};

    %get image file names, initial state, and ground truth for evaluation
    [img_files, pos, target_sz, ~, video_path,datasetParam] = load_video_info(base_path, video,'RGBD');

    [rects, time] = nsamf(video_path, img_files, pos, target_sz,1);


    fps = numel(img_files) / time;

    fprintf('%12s - FPS:% 4.2f\n', video,  fps);

%     save([outputpath video '.mat' ],'rects','fps');
    result=rects; result(:,3:4) = rects(:,1:2) + rects(:,3:4);
    dlmwrite([outputpath video '.txt'],result);

        
  end


% 
% %% load input output 
% [source.imageNames, source.numOfFrames,seq_name] = loadInput(source.dataType, source.directory);
% source.startFrame = 1;
% % if ~exist(outputpath,'dir'), mkdir(outputpath);end
% % detail_output=[control.detectionMode num2str(control.enableRecenter) num2str(control.occlusionhandle)];
% % if control.savevideo,
% %     outputVideo = VideoWriter([outputpath seq_name '_' detail_output]);
% %     outputVideo.FrameRate = 10;
% %     open(outputVideo);
% %     if control.debug>0
% %         outputVideo2 = VideoWriter([outputpath seq_name '_' detail_output '_hist']);
% %         outputVideo2.FrameRate = 10;
% %         open(outputVideo2);
% %     end
% % end
% %% initialization
% % first frame data
% [framePrev.rgb, framePrev.depth] = readFrame(source.dataType, source.imageNames, source.startFrame);
% framePrev.underOcclusion = 0;
% if exist([source.directory 'init.txt'],'file')&&source.startFrame==1;
%     bb = dlmread ([source.directory 'init.txt']);
%     bb(3:4)=bb(3:4)+bb(1:2);
%     framePrev.bb = bb(:);
% else
%     framePrev.bb = bb_click(framePrev.rgb);
%     if source.startFrame==1,
%         bbinit=framePrev.bb;
%         bbinit(3:4)=bbinit(3:4)-bbinit(1:2);
%         dlmwrite([source.directory 'init.txt'],bbinit');
%     end
% end
% framePrev.occBB=[];
% [framePrev.distribution, framePrev.targetDepth] = initDistribution(framePrev.bb, framePrev.rgb, framePrev.depth, control);
% fprintf('sigma: %f\n', framePrev.distribution.depth.Sigma);
% 
% % svm classifier
% if control.filterRGB, framePrev.rgb = framePrev.rgb .* uint8(repmat((framePrev.depth>(framePrev.distribution.depth.mu-5* framePrev.distribution.depth.Sigma)), [1 1 3])); end
% svm=struct('thr',nan,'pSV',[],'nSV',[],'w',[],'b',0,'tnex',[],'tpex',[],'level',nan,'scale',nan);
% svm.maxsv=200;            
% svm = hogInitDetector(svm, framePrev.bb, getFeaturePym(control.detectionMode, framePrev.rgb, framePrev.depth, svm.scale));
% 
% % occlusion
% targetInfo.firstBB = framePrev.bb;
% targetInfo.targetDepth=framePrev.targetDepth;
% % time
% toc;tic;
% % data to save
% resultBBs = framePrev.bb;
% resultConfs = 2*svm.thr;
% resultState =0;
% resultOccBBs=nan(4,1);
% %% processing each frame
% for frameId = source.startFrame+1:source.numOfFrames
%     fprintf('processing frame %d...\n', frameId);
%     % read current frame
%     [frameCurr.rgb, frameCurr.depth] = readFrame(source.dataType, source.imageNames, frameId);
%     [frameCurr, svm] = processFrame(frameId, frameCurr, framePrev, svm,targetInfo, control);
%     if control.showResult,showResult(framePrev,frameCurr,frameId,source,control);end
%     
%     % save video
%     if control.savevideo,
%         h = figure(2);
%         set(h,'resize','off');
%         frameToSave = getframe(h);
%         writeVideo(outputVideo,frameToSave);
%     
%         h2 = figure(4);
%         set(h2,'resize','off');
%         frameToSave2 = getframe(h2);
%         writeVideo(outputVideo2,frameToSave2);
%     end 
%     % save variable
%     if isempty(frameCurr.bb), resultBBs = [resultBBs, nan(4,1)];
%     else resultBBs = [resultBBs, frameCurr.bb]; end
%     if isempty(frameCurr.conf), resultConfs = [resultConfs, nan];
%     else resultConfs = [resultConfs, frameCurr.conf]; end
%     resultState = [resultState framePrev.underOcclusion ];
%     
%     if isempty(frameCurr.occBB), resultOccBBs = [resultOccBBs, nan(4,1)];
%     else resultOccBBs = [resultOccBBs, frameCurr.occBB]; end
%     %free memory
%     framePrev = frameCurr;
%     clear frameCurr;
% end
% 
% %% finish
% % save([outputpath seq_name '_' detail_output '.mat' ],'resultBBs','resultConfs','resultState','resultOccBBs','control');
% result=[resultBBs' resultState'];
% dlmwrite([outputpath seq_name '.txt'],result);
% 
% if control.savevideo,
%     close(outputVideo);
%     if control.debug>0,close(outputVideo2);end
% end
