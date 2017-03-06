function results=run_Struck(seq, res_path, bSaveImage)

close all;

x=seq.init_rect(1)-1;%matlab to c
y=seq.init_rect(2)-1;
w=seq.init_rect(3);
h=seq.init_rect(4);

% %Hackish way to remove space from my path, would have been required if the
% %path had spaces
% path_with_spaces = seq.path(1:22);
% path_with_spaces = strcat(path_with_spaces, 'D~1\Dataset_UAV123\UAV123\data_seq\UAV123\cyclist0\');

tic
% command = ['struck.exe haar gaussian 0.2 100 100 30 10 ' num2str(bSaveImage) ' ' num2str(bSaveImage) ' ' seq.name ' ' seq.path ' ' num2str(seq.startFrame) ' ' num2str(seq.endFrame) ' '  num2str(seq.nz) ' ' seq.ext ' ' num2str(x) ' ' num2str(y) ' ' num2str(w) ' ' num2str(h)];
command = ['struck.exe ' num2str(x) ' ' num2str(y) ' ' num2str(w) ' ' num2str(h) ' ' num2str(seq.startFrame) ' ' num2str(seq.endFrame) ' '  seq.path];
dos(command);
duration=toc;

results.res = dlmread('log.txt');
results.res(:,1:2) =results.res(:,1:2) + 1;%c to matlab

results.type='rect';
results.fps = seq.len / duration;

disp(results.fps)
