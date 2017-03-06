function [model,param] = trackNSAMF(img,model,param)

pos=model.last_pos;
sz=param.features.sz;
target_sz=model.last_target_sz;
responseR = zeros(4,size(param.search_size,2));
%debug
finalmaps={};
colormap={};
%debug
for i=1:size(param.search_size,2)
    tmp_sz = floor((target_sz * (1 + param.padding))* param.search_size(i));
    
    patch = getPatch(img,pos,tmp_sz, param.window_sz);
    rawdata = prepareData(patch, param.features);
    data = calculateFeatures(rawdata, param.features, param.cos_window);
%debug
%        colormap{i} = rawdata.colorProb;
%debug
    spaces = numel(data);
    finalmap=ones(sz);
    scalemap=ones(sz);
    for j=1:spaces
        kzf = customized_correlation(fft2(data{j}), model.model_xf{j}, param);
        tmpresponse = real(ifft2(model.model_alphaf{j} .* kzf));
        
        %filter the map
        tmpresponse(tmpresponse<0) = 0;
%         tmpresponse(tmpresponse>1) = 1;
        psr= PSR(tmpresponse,0.05);
%         if j==3
%             scalemap = tmpresponse;
%             tmpresponse = plateMap(tmpresponse,0.25);
%         end
%         if j==4
%             tmpresponse = plateMap(tmpresponse,0.25);
%         end
%         if j==5
%             tmpresponse = plateMap(tmpresponse,0);
%         end
%         if j==1
%             
%         end
        finalmap = tmpresponse .* finalmap;

    end
    %debug
    finalmaps{i}=finalmap;
    %debug
    m =  max(finalmap(:));
    m2 =  max(scalemap(:));
    [vert_delta, horiz_delta] = find(finalmap ==m, 1);
    if vert_delta > sz(1) / 2,  %wrap around to negative half-space of vertical axis
        vert_delta = vert_delta - sz(1);
    end
    if horiz_delta > sz(2) / 2,  %same for horizontal axis
        horiz_delta = horiz_delta - sz(2);
    end
     current_size = tmp_sz(2)/param.window_sz(2);
     tmpPos = pos + current_size* param.features.cell_size * [vert_delta - 1, horiz_delta - 1];
     responseR(:,i) = [m tmpPos m2];
end

[~, szid] = max(responseR(1,:));
model.pos = responseR(2:3,szid)';
%debug
d=fftshift(finalmaps{szid});
param.display{1}=100*d./sum(d(:));
%  param.display{2}=colormap{szid};
%debug

[~, szid2] = max(responseR(4,:));
model.target_sz = target_sz * param.search_size(szid);
param.target_sz = target_sz * param.search_size(szid2);
end



function [ response ] = plateMap( response, rate )
    %PSR Summary of this function goes here
    %   Detailed explanation goes here
    maxresponse = max(response(:))*rate;
%           x = sort(response(:),'descend');
%           id = find(x<maxresponse);
%           fprintf('%d\n',id(1));
    response(response>=maxresponse)=1;
    response(response<maxresponse)=0;
    
    
%       tn = numel(response);

%       theshold = x(floor(tn*rate)+1);
%       response(response>theshold)=1;
%       response(response<=theshold)=0;
%     sz = size(response);
%     %calculate the PSR
%     range = ceil(sqrt(numel(response))*rate);
%     iresponse=fftshift(response);
%     [xx, yy] = find(iresponse == maxresponse, 1);
%     idx = xx-range:xx+range;
%     idy = yy-range:yy+range;
%     idy(idy<1)=1;idx(idx<1)=1;
%     idy(idy>sz(2))=sz(2);idx(idx>sz(1))=sz(1);
%     centerMap = iresponse(idx,idy);
%     m = mean(centerMap(:));
%     centerMap(centerMap<m)=0;
%     centerMap(centerMap>=m)=1;
%     response = zeros(sz);
%     response(idx,idy)=centerMap;
%     response=ifftshift(response);
    

end
function [ psr ] = PSR( response, rate )
%PSR Summary of this function goes here
%   Detailed explanation goes here
maxresponse = max(response(:));
%calculate the PSR
range = ceil(sqrt(numel(response))*rate);
response=fftshift(response);
[xx, yy] = find(response == maxresponse, 1);
idx = xx-range:xx+range;
idy = yy-range:yy+range;
idy(idy<1)=1;idx(idx<1)=1;
idy(idy>size(response,2))=size(response,2);idx(idx>size(response,1))=size(response,1);
response(idx,idy)=0;
m = sum(response(:))/numel(response);
d=sqrt(size(response(:),1)*var(response(:))/numel(response));
psr =(maxresponse - m)/d ;

end
