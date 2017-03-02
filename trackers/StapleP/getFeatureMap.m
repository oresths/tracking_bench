function data = getFeatureMap(im_patch, feature_type, cf_response_size, hog_cell_size, ...
     bg_hist, fg_hist, n_bins, grayscale_sequence, cos_window)

% code from DSST
data={};
id = 1;
% allocate space
switch feature_type
    case 'fhog'
        temp = fhog(single(im_patch), hog_cell_size);
        h = cf_response_size(1);
        w = cf_response_size(2);
        out = zeros(h, w, 28, 'single');
        out(:,:,2:28) = temp(:,:,1:27);
        if hog_cell_size > 1
            im_patch = mexResize(im_patch, [h, w] ,'auto');
        end
        % if color image
        if size(im_patch, 3) > 1
            im_patch = rgb2gray(im_patch);
        end
        out(:,:,1) = single(im_patch)/255 - 0.5;
    case 'gray'
        if hog_cell_size > 1, im_patch = mexResize(im_patch,cf_response_size,'auto');   end
        if size(im_patch, 3) == 1
            out = single(im_patch)/255 - 0.5;
        else
            out = single(rgb2gray(im_patch))/255 - 0.5;
        end        
    case 'nsamf'
        %grey
        h = cf_response_size(1);
        w = cf_response_size(2);
        if hog_cell_size > 1
            im_patch_fsz = mexResize(im_patch, [h, w] ,'auto');
        end
        if size(im_patch, 3) > 1  % if color image
            im_patch_fsz_grey = rgb2gray(im_patch_fsz);
        else
            im_patch_fsz_grey = im_patch_fsz;
        end
        data{id} = single(im_patch_fsz_grey)/255 - 0.5;
%         id = id + 1;
        
        %HOG
        temp = fhog(single(im_patch), hog_cell_size);
%         data{id} = temp(:,:,1:27);
%         id = id + 1;
        data{1} = cat(3,data{1},temp(:,:,1:27));
        
        
        %ColorProb
        likelihood_map_ori = getColourMap(im_patch, bg_hist, fg_hist, n_bins, grayscale_sequence);
        likelihood_map_ori(isnan(likelihood_map_ori)) = 0;
        likelihood_map = mexResize(likelihood_map_ori, [h, w] ,'auto');
        % (TODO) in theory it should be at 0.5 (unseen colors shoud have max entropy)
        likelihood_map(isnan(likelihood_map)) = 0;
        temp = likelihood_map - mean(likelihood_map(:));
%         data{id} = temp;
%         id = id + 1;
        data{1} = cat(3,data{1},temp);
        
        %ColorProbHOG
        
        temp = double(fhog(single(likelihood_map_ori) , hog_cell_size));
        data{1} =cat(3,data{1},temp(:,:,1:27));
%         data{id} = temp(:,:,1:27);
end

for i=1:numel(data)
    data{i}= bsxfun(@times, data{i}, cos_window);
end
        
end

