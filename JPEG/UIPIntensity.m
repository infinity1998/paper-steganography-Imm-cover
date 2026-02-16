function [texture] = UIPIntensity(stego_ori)
%% Get 2D wavelet filters - Daubechies 8
% 1D high pass decomposition filter
hpdf = [-0.0544158422, 0.3128715909, -0.6756307363, 0.5853546837, 0.0158291053, -0.2840155430, -0.0004724846, 0.1287474266, 0.0173693010, -0.0440882539, ...
        -0.0139810279, 0.0087460940, 0.0048703530, -0.0003917404, -0.0006754494, -0.0001174768];
% 1D low pass decomposition filter
lpdf = (-1).^(0:numel(hpdf)-1).*fliplr(hpdf);
% construction of 2D wavelet filters
F{1} = lpdf'*hpdf;
F{2} = hpdf'*lpdf;
F{3} = hpdf'*hpdf;

%% Get embedding costs
% inicialization
stego_ori = double(stego_ori);
sizeStegoori = size(stego_ori);

% add padding
padSize = max([size(F{1})'; size(F{2})'; size(F{3})']);
stegoPadded = padarray(stego_ori, [padSize padSize], 'symmetric');

R1 = conv2(stegoPadded, F{1}, 'same');
R2 = conv2(stegoPadded, F{2}, 'same');
R3 = conv2(stegoPadded, F{3}, 'same');


R1 = R1(((size(R1, 1)-sizeStegoori(1))/2)+1:end-((size(R1, 1)-sizeStegoori(1))/2), ((size(R1, 2)-sizeStegoori(2))/2)+1:end-((size(R1, 2)-sizeStegoori(2))/2));
R2 = R2(((size(R2, 1)-sizeStegoori(1))/2)+1:end-((size(R2, 1)-sizeStegoori(1))/2), ((size(R2, 2)-sizeStegoori(2))/2)+1:end-((size(R2, 2)-sizeStegoori(2))/2));
R3 = R3(((size(R3, 1)-sizeStegoori(1))/2)+1:end-((size(R3, 1)-sizeStegoori(1))/2), ((size(R3, 2)-sizeStegoori(2))/2)+1:end-((size(R3, 2)-sizeStegoori(2))/2));

texture = abs(R1) + abs(R2) + abs(R3);
end