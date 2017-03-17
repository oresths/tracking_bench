function [ thresholdSetOverlap, successOverlap ] = timeLost( seqs, trackers )
%TIMELOST Summary of this function goes here
%   Detailed explanation goes here

thresholdSetOverlap = 1:-0.05:0;

pathAnno = './anno/';
numTrk = length(trackers);

rpAll=['.\results\results_OPE\'];

successOverlap = zeros(length(thresholdSetOverlap), length(trackers), length(seqs));
aveSuccessOverlap = zeros(length(thresholdSetOverlap), length(trackers));
seqNames = cell(length(seqs),1);
trkNames = cell(length(trackers),1);

for idxSeq=1:length(seqs)
    s = seqs{idxSeq};
    seqNames{idxSeq} = s.name;
    
    rect_anno = dlmread([pathAnno s.name '.txt']);
    anno = rect_anno;
    nameAll=[];
    for idxTrk=1:numTrk
        
        t = trackers{idxTrk};
        trkNames{idxTrk} = t.name;
        %         load([rpAll s.name '_' t.name '.mat'], 'results','coverage','errCenter');
        
        load([rpAll s.name '_' t.name '.mat'])
%         disp([s.name ' ' t.name]);
        
        res = results{1};
        
        len = size(anno,1);
        
        if isempty(res)
            break;
        elseif isempty(res.res)
            break;
        end
        
        if ~isfield(res,'type')&&isfield(res,'transformType')
            res.type = res.transformType;
            res.res = res.res';
        end
        
        
        [~, ~, errCoverage, errCenter] = calcSeqErrRobust(res, anno);
        
        for tIdx=1:length(thresholdSetOverlap)
            firstLost = find(errCoverage <= thresholdSetOverlap(tIdx),1,'first');
            if isempty(firstLost)
                successOverlap(tIdx, idxTrk, idxSeq) = 1;
            else
                successOverlap(tIdx, idxTrk, idxSeq) = firstLost / len;
            end
        end
    end    
    aveSuccessOverlap = aveSuccessOverlap + successOverlap(:, :, idxSeq);   
end

aveSuccessOverlap = aveSuccessOverlap / length(seqs);

for i=1:length(seqs) + 1
    figure(i)
    if i > length(seqs)
        imagesc(aveSuccessOverlap)
%         surf(1:length(trackers), thresholdSetOverlap, aveSuccessOverlap)
        title('Average Duration of overlap')
    else
        imagesc(successOverlap(:,:,i))
%         surf(1:length(trackers), thresholdSetOverlap, successOverlap(:,:,i))
        title(['Duration of overlap for  - ' seqNames{i}])
    end
    set(gca, 'ydir', 'normal')
%     set(gca, 'ydir', 'reverse')
    % ylim([Y(end), Y(1)]);
%     xlim([1 length(trackers)])
%     shading('interp')
%     camlight left
%     lighting phong
%     xlabel('Tracker Names')
    ticks = 1:length(trackers);
    set(gca,'XTick',ticks)
    set(gca,'XTickLabel', trkNames )
    xtickangle(45)
    
    numOfTicks = length(thresholdSetOverlap);
    step = numOfTicks / 10;
    yticks = 1:step:numOfTicks;
    set(gca,'YTick', yticks )
    set(gca,'YTickLabel', 100:-10:0 )
    ylabel('Overlap (%)')
    
    zlabel('Normalized Time')
%     colormap jet
    c = colorbar;
    c.Label.String = 'Normalized Time';
    view([0,90])
end

debug=1;
end

