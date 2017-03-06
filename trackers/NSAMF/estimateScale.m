function [ ps1 ] = estimateScale( cmap )
%ESTIMATESCALE Summary of this function goes here
%   Detailed explanation goes here
ps1=[];
regions = detectMSERFeatures(cmap);
if regions.Count>0
sz = size(cmap);
% find the fixest one
d = zeros(regions.Count,1);
for i=1:regions.Count
    p = regions.PixelList{i};
    area = 0.25*prod(regions.Axes(i,:));
    id=(p(:,1)-1)*sz(1)+p(:,2);
    area2=sum(cmap(id));
    d(i) =  area2/ area;
end

[~,id] = max(d);

center = regions.Location(id,:);

Axes = regions.Axes(id,:)/2;

o = regions.Orientation(id);

a = [Axes(2)* sin(o), Axes(2) *cos(o)];
b = [Axes(1) * sin(pi/2+o),Axes(1)*cos(pi/2+o) ];
dis=center-sz([2 1])/2;
if sum(abs(dis)>abs(sz*0.1))>0 || prod(Axes)>prod(sz*0.3) || regions.Count>5
    ps1=[];
    return
end
% ps = [-a-b;b-a;a+b;a-b;-a-b]+repmat(center,[5 1]);
ps1 = [-a-b;b-a;a+b;a-b;-a-b]+repmat(dis,[5 1]);
% figure(10)
% imshow(cmap);
% hold on
% plot(ps(:,1),ps(:,2));
% for i=1:regions.Count
% plot(regions(i))
% end
% hold off
end
end

