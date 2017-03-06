function [modelXf, modelAlphaf] = calculateModel(data,model,param)

spaces = numel(data);
modelXf = cell(spaces,0);
modelAlphaf = cell(spaces,0);
for i=1:spaces
    xf = fft2(data{i});

%Kernel Ridge Regression, calculate alphas (in Fourier domain)
    kf = customized_correlation(xf, xf, param);
    modelAlphaf{i} = model.yf ./ (kf + param.lambda);   %equation for fast training
    modelXf{i} = xf;
end


end