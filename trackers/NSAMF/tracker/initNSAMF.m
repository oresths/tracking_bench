function [model, param] = initNSAMF(img, pos, target_sz)

model = {};
param = readParam();
%calculate parameters
resize_image = (sqrt(prod(target_sz)) >= param.thresholdForResize);
if resize_image
    img = imresize(img,0.5);
    pos = floor(pos / 2);
    target_sz = floor(target_sz / 2);
end
window_sz = floor(target_sz * (1 + param.padding));
if param.features.colorProbHoG || param.features.greyHoG || param.features.cnn
    sz=floor(window_sz / param.features.cell_size);
else
    sz = window_sz;
    param.features.cell_size = 1;
end
output_sigma = sqrt(prod(target_sz)) * param.output_sigma_factor /...
    param.features.cell_size;
cos_window = hann(sz(1)) *hann(sz(2))';	

model.yf = fft2(gaussian_shaped_labels(output_sigma, sz));

param.window_sz = window_sz;
% param.output_sigma = output_sigma;
param.resize_image= resize_image;
param.cos_window = cos_window;
param.features.sz = sz;

%create model



patch = getPatch(img,pos,window_sz, window_sz);
if size(patch,3)==1
    param.features.colorProb=0;
    param.features.colorProbHoG=0;
    param.features.colorName = 0;
end
param.features = updateFeatures(patch, param.features);
rawdata = prepareData(patch, param.features);
data = calculateFeatures(rawdata, param.features,param.cos_window);



[xf, alphaf] = calculateModel(data,model,param);


model.model_alphaf = alphaf;
model.model_xf = xf;

model.last_pos=pos;
model.last_target_sz = target_sz;
model.target_sz = target_sz;
model.pos = pos;
param.target_sz = target_sz;
end
