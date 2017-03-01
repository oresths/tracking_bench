rects = [positions(:,1), positions(:,2)];
rects(:,3) = target_sz(2);
rects(:,4) = target_sz(1);
disp(['fps: ' num2str(fps)])
results.type = 'rect';
results.res = rects;
results.fps = fps;