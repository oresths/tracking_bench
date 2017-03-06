%
%coded by Li, Yang

function param = readParam()

param={};

%set parameters
param.visualization=1;
param.debug = 0;

param.thresholdForResize = 100;

param.kernel_type = 'linear'; 
param.kernel_sigma = 0.5;
param.padding = 1.5;  %extra area surrounding the target
param.lambda = 1e-4;  %regularization
param.output_sigma_factor = 0.1;  %spatial bandwidth 

param.interp_factor = 0.01;
param.features.colorUpdateRate = 0.01;
        
      
types = {'grey','greyHoG','colorProb','colorProbHoG'};%'gist','cnn' ,'lbp' ,'colorName','greyProb'
param.features.types=types;
param.features.hog_orientations = 9;
param.features.nbin =10;
param.features.cell_size = 4;

param.features.gparam.orientationsPerScale = [4 4 4 4];
param.features.gparam.fc_prefilt = 4;

temp = load('w2crs');
param.features.w2c = temp.w2crs;
param.features.colorTransform = makecform('srgb2lab');
param.features.interPatchRate = 0.3;

temp = load('filters');
param.features.filters = temp.filters;

param.features.grey=0;
param.features.greyHoG=0;
param.features.colorProb=0;
param.features.colorProbHoG=0;
param.features.colorName=0;
param.features.greyProb=0;
param.features.lbp=0;
param.features.gist=0;
param.features.cnn=0;

for i=1:numel(types)
   switch types{i}
       case 'grey'
           param.features.grey=1;
       case 'greyHoG'
           param.features.greyHoG=1;
       case 'colorProb'
           param.features.colorProb=1;
       case 'colorProbHoG'
           param.features.colorProbHoG=1;
       case 'colorName'
           param.features.colorName=1;
       case 'greyProb'
           param.features.greyProb=1;
       case 'lbp'   
           param.features.lbp=1;
       case 'gist'   
           param.features.gist=1;
       case 'cnn'   
           param.features.cnn=1;
   end
    
end


param.search_size = [1 0.985 0.99 0.995 1.005 1.01 1.015];%


end