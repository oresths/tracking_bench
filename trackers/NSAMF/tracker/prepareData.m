function data=prepareData(patch, features)
    
    data.patch = patch;
    data.cImg = double(patch)/255;

    if features.grey || features.greyHoG || features.greyProb
        if size(patch,3)>1
            data.gImg = double(rgb2gray(patch))/255;
            data.grey = rgb2gray(patch);
        else
            data.gImg = double(patch)/255;
            data.grey = patch;
        end
    end
    

    if features.colorProb || features.colorProbHoG
%         data.labImg = applycform(patch, features.colorTransform);data.labImg
        data.colorProb = getColorSpace(patch,features.pi,features.pl);
    end


    if features.greyProb
        fakeP = cat(3,data.grey,data.grey);
        fakeP = cat(3,fakeP,data.grey);
        data.greyProb = getColorSpace(fakeP,features.greyPi,features.greyPl);
    end

                
    
    

    
end