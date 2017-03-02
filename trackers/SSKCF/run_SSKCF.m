function results = run_SSKCF(seq, res_path, bSaveImage)

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

tic
tracker_command = '.\SumShiftKCF.exe';
dos(tracker_command);
duration=toc;

temp_res = dlmread('output.txt');

results.res = [ temp_res(:,[1 2]) temp_res(:,5)-temp_res(:,1) temp_res(:,6)-temp_res(:,2) ];

results.type='rect';
results.fps=seq.len/duration;

disp(results.fps)