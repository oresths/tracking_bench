function [model,param] = updateNSAMF(img,model,param)

tmp_sz = floor((model.target_sz * (1 + param.padding)));
patch = getPatch(img,model.pos,tmp_sz, param.window_sz);

rawdata = prepareData(patch, param.features);
data = calculateFeatures(rawdata, param.features, param.cos_window);

[xf, alphaf] = calculateModel(data,model,param);


spaces = numel(data);
for i=1:spaces
    
    model.model_alphaf{i} = (1 - param.interp_factor) * model.model_alphaf{i} + ...
    param.interp_factor * alphaf{i};
    model.model_xf{i} = (1 - param.interp_factor) * model.model_xf{i} + ...
    param.interp_factor * xf{i};
    
end

param.features = updateFeatures(patch, param.features);

model.last_pos = model.pos;
model.last_target_sz = model.target_sz;

% ps=estimateScale(rawdata.colorProb);
% if ps
%     ps = ps(:,[2 1])*tmp_sz(1)/param.window_sz(1)+repmat(model.pos,[5 1]); 
%     x1 = min(ps(:,1));
%     x2 = max(ps(:,1));
%     y1 = min(ps(:,2));
%     y2 = max(ps(:,2));
%     model.target_sz = [x2 - x1, y2 - y1];
%     model.pos = [x1+0.5*model.target_sz(1), y1 + 0.5*model.target_sz(2)];
%     model.polygon = ps;
% else
% model.target_sz=param.target_sz;
% end
end