function results = run_DSST_C(seq, res_path, bSaveImage)

dlmwrite('region.txt', seq.init_rect);

fid = fopen('images.txt','wt');
[rows,~] = size(seq.s_frames);
for i=1:rows-1
      fprintf(fid,'%s,',seq.s_frames{i,1:end-1});
      fprintf(fid,'%s\n',seq.s_frames{i,end});
end
fprintf(fid,'%s,',seq.s_frames{rows, 1:end-1});
fprintf(fid,'%s\n',seq.s_frames{rows, end});
fclose(fid);

% tic
tracker_command = '.\DSSTcpp.exe';
dos(tracker_command);
% duration=toc;

results.res = dlmread('output.txt');
results.type='rect';
% results.fps = seq.len / duration;
results.fps = dlmread('fps.txt');

disp(results.fps)