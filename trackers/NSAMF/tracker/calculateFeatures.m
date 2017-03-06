function data = calculateFeatures(rawdata, features,cos_window)
    data={};
    id = 1;

    if features.grey 
       x= rawdata.gImg;
       if ~equalSZ(x,features.sz)
           x = imresize(x,features.sz);
       end
       x= x - mean(x(:));
%        data{5} =x;
       data{id} = x;
       id =id +1;
 
    end
    
    if features.colorProb 
        x = rawdata.colorProb;
        if ~equalSZ(x,features.sz)
           x = imresize(x,features.sz);
        end
        x= x - mean(x(:));
        data{1} =cat(3,data{1},x);
%  %x;      data{2}=cat(3,data{2},x);
         data{id} = x;
         id =id +1;
    end
    
    if features.greyProb 
        x = rawdata.greyProb;
        if ~equalSZ(x,features.sz)
           x = imresize(x,features.sz);
        end
        x= x - mean(x(:));
        data{1} =cat(3,data{1},x);
%         data{2}=cat(3,data{2},x);
%         data{id} = x;
%         id =id +1;%x;
    end
    
    if features.colorName
        x= rawdata.patch;
        if ~equalSZ(x,features.sz)
           x = imresize(x,features.sz);
       end
       x = get_feature_map(x, 'cn', features.w2c);
       data{1} =cat(3,data{1},x);
        data{id} = x; % %
        id =id +1;
    end
        
    if features.greyHoG
        x = double(fhog(single(rawdata.gImg), features.cell_size, features.hog_orientations));
        x(:,:,end) = [];
        data{1} =cat(3,data{1},x);
        data{id} = x;
        id =id +1;
    end


    
    if features.colorProbHoG
        x = double(fhog(single(rawdata.colorProb) , features.cell_size, features.hog_orientations));
        data{1} =cat(3,data{1},x);
        data{id} = x;
        id =id +1;
    end
    
    if features.lbp

        x = LBPmap(rawdata.grey);  
        data{1} =cat(3,data{1},x);
%         id =id +1;
    end
    
    
    if features.gist
   
        [w, h] = size(rawdata.grey);
        
        features.gparam.imageSize = [w h]; % it works also with non-square images
        features.gparam.numberBlocks = [floor(w/features.cell_size) floor(h/features.cell_size)];

        % Computing gist requires 1) prefilter image, 2) filter image and collect
        % output energies
        [x, features.gparam] = LMgist(rawdata.grey, '', features.gparam);
        data{1} =cat(3,data{1},x);
%         data{id} = x;
%         id =id +1;
    end
    
    if features.cnn
   
        x= double(rawdata.cImg);
        x= x - mean(x(:));
        x = cnnfilters(x,features.filters,features.cell_size);

%         for i=1:96
%             data{id+i-1}=x(:,:,(i-1)+1:i*3);
%         end
%         data{id} =x;
%         id =id +1;
        data{1} =cat(3,data{1},x);
        
    end

    
    
    for i=1:numel(data)
        data{i}= bsxfun(@times, data{i}, cos_window);
    end

end


function r = equalSZ(x,sz)
    tmp = size(x);
    r = prod(tmp(1:2)==sz(1:2));
end