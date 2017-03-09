function genFpsMat(seqs, trackers, evalType, nameTrkAll, perfMatPath)

numTrk = length(trackers);
numSeqs = length(seqs);

fps_all = zeros(numTrk, numSeqs);

switch evalType
    case 'SRE'
        rpAll=['.\results\results_SRE\'];
    case {'TRE'}
        rpAll=['.\results\results_TRE\'];
    case {'OPE'}
        rpAll=['.\results\results_OPE\'];
end

for idxSeq=1:length(seqs)
    s = seqs{idxSeq};

    for idxTrk=1:numTrk
        
        t = trackers{idxTrk};
        
        load([rpAll s.name '_' t.name '.mat'])
        disp([s.name ' ' t.name]);
        
        switch evalType
            case 'SRE'
                idxNum = length(results);
            case 'TRE'
                idxNum = length(results);
            case 'OPE'
                idxNum = 1;
        end
         
        for idx = 1:idxNum
            res = results{idx};
            
            if isempty(res)
                break;
            elseif isempty(res.res)
                break;
            end
            
            if ~isfield(res,'type')&&isfield(res,'transformType')
                res.type = res.transformType;
                res.res = res.res';
            end
            
            fps_all(idxTrk, idxSeq) = fps_all(idxTrk, idxSeq) + res.fps;            
        end
        
        fps_all(idxTrk, idxSeq) = fps_all(idxTrk, idxSeq) / idxNum;
    end
end

fps_all = sum(fps_all, 2) / numSeqs;

dataName1=[perfMatPath 'fps_all' num2str(numTrk) '.mat'];
save(dataName1,'fps_all');

