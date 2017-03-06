function data2 = cnnfilters(x,filters,cell_size)

    num = numel(filters);
    sz = size(x);
    raw = zeros([sz(1),sz(2),num]);
    for i=1:num
        tmp=zeros(sz(1),sz(2));
        for j=1:sz(3)
            tmp = tmp+conv2(x(:,:,j),filters{i}(:,:,4-j),'same');
%             tmp = tmp./sum(tmp(:));
            
        end
        raw(:,:,i) = tmp;
    end
        
    N = [floor(sz(1)/cell_size)  floor(sz(2)/cell_size)];
    data  = zeros([N(1), N(2),num]);
    data2  = zeros([N(1), N(2),num]);
    for xx = 1:cell_size
        for yy=1:cell_size
            %y= y+x(xx:cell_size:N(1)*cell_size,yy:cell_size:N(2)*cell_size);
%             data= max(data,raw(xx:cell_size:N(1)*cell_size,yy:cell_size:N(2)*cell_size,:));
            
                [a,id]=max(raw(xx:cell_size:N(1)*cell_size,yy:cell_size:N(2)*cell_size,:),[],3);
                for i=1:N(1)
                    for j=1:N(2)
                        data2(i,j,id(i,j)) =data2(i,j,id(i,j)) + a(i,j);
                    end
                end
        end
    end
   
%norm

s = sum(data2.^2,3); s=sqrt(sum(s(:)));

data2 =data2/s;


    
end