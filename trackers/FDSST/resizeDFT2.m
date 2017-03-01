function resizeddft  = resizeDFT2(inputdft, desiredSize)

imsz = size(inputdft);
minsz = min(imsz, desiredSize);

scaling = prod(desiredSize)/prod(imsz);

resizeddft = complex(zeros(desiredSize, 'single'));

mids = ceil(minsz/2);
mide = floor((minsz-1)/2) - 1;

resizeddft(1:mids(1), 1:mids(2)) = scaling * inputdft(1:mids(1), 1:mids(2));
resizeddft(1:mids(1), end - mide(2):end) = scaling * inputdft(1:mids(1), end - mide(2):end);
resizeddft(end - mide(1):end, 1:mids(2)) = scaling * inputdft(end - mide(1):end, 1:mids(2));
resizeddft(end - mide(1):end, end - mide(2):end) = scaling * inputdft(end - mide(1):end, end - mide(2):end);
end