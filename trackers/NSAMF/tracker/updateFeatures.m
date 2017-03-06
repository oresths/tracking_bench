function features = updateFeatures(patch, features)



if (features.colorProb || features.colorProbHoG)
    sz = size(patch);
    sz = sz(1:2);
    pos = sz/2;
    labPatch = patch;%applycform(patch, features.colorTransform);
    interPatch = get_subwindow(labPatch, pos, sz*features.interPatchRate);
    features.interPatch = interPatch;
    pl = getColorSpaceHist(labPatch,features.nbin);
    pi = getColorSpaceHist(interPatch,features.nbin);
    if isfield(features,'pl')
        features.pi = (1 - features.colorUpdateRate) * features.pi +...
            features.colorUpdateRate * pi;
        features.pl = (1 - features.colorUpdateRate) * features.pl + ...
            features.colorUpdateRate * pl;
    else
        features.pl = pl;
        features.pi = pi;
    end
end


if (features.greyProb)
    if size(patch,3)>1
        greyPatch = rgb2gray(patch);
    else
        greyPatch = patch;
    end
    fakeP = cat(3,greyPatch,greyPatch);
    fakeP = cat(3,fakeP,greyPatch);
    sz = size(fakeP);
    sz = sz(1:2);
    pos = sz/2;
    interFakeP = get_subwindow(fakeP, pos, sz*0.3);
    pl = getColorSpaceHist(fakeP,features.nbin);
    pi = getColorSpaceHist(interFakeP,features.nbin);
    if isfield(features,'greyPl')
        features.greyPi = (1 - features.colorUpdateRate) * features.greyPi +...
            features.colorUpdateRate * pi;
        features.greyPl = (1 - features.colorUpdateRate) * features.greyPl + ...
            features.colorUpdateRate * pl;
    else
        features.greyPl = pl;
        features.greyPi = pi;
    end
end

%         case 'basis',
%             %           [basis k] =bestBasis(data,reDim);
%             old=features;
%             old.type='hogcolor';
%             data= get_features(patch, old, cell_size, cos_window);
%             sz = size(data); data =reshape(data,[sz(1)*sz(2) sz(3)]);
%             [basis v]=pca(data);basis=basis(:,1:features.reDim)';
%             features.basis=basis;
%         case 'chist'
%             colorTransform = makecform('srgb2lab');
%             patch =applycform(patch, colorTransform);


end