function y = LBPmap(I)



SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
 
[n,m,~] = size(I);
F = zeros(n,m);
F(2:n-1,2:m-1)= double(lbp(I,SP,0,'i'))/255;
cell_size = 4;
N = [floor(n/cell_size)  floor(m/cell_size)];
y  = zeros(N(1), N(2));
 
for xx = 1:cell_size
    for yy=1:cell_size
        %y= y+x(xx:cell_size:N(1)*cell_size,yy:cell_size:N(2)*cell_size);
        y= max(y,F(xx:cell_size:N(1)*cell_size,yy:cell_size:N(2)*cell_size));
    end
end
 



end
