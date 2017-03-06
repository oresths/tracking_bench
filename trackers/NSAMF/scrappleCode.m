a=filters;
sz = size(a);
filters ={};

for i=1:sz(1)
    tm = zeros([11,11,3]);
    tm(:,:,1)=a(i,1,:,:);
    tm(:,:,2)=a(i,2,:,:);
    tm(:,:,3)=a(i,3,:,:);
    
    filters{i}=tm;
    
end