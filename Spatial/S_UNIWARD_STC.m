function [rhoP1,rhoM1,rho0] = S_UNIWARD_STC(cover)
sgm = 1;
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
cover = double(cover);
wetCost = 10^8;
[k,l] = size(cover);

% add padding
padSize = max([size(F{1})'; size(F{2})'; size(F{3})']);
coverPadded = padarray(cover, [padSize padSize], 'symmetric');

xi = cell(3, 1);
for fIndex = 1:3
    % compute residual
    R = conv2(coverPadded, F{fIndex}, 'same');
    % compute suitability
    xi{fIndex} = conv2(1./(abs(R)+sgm), rot90(abs(F{fIndex}), 2), 'same');
    % correct the suitability shift if filter size is even
    if mod(size(F{fIndex}, 1), 2) == 0, xi{fIndex} = circshift(xi{fIndex}, [1, 0]); end;
    if mod(size(F{fIndex}, 2), 2) == 0, xi{fIndex} = circshift(xi{fIndex}, [0, 1]); end;
    % remove padding
    xi{fIndex} = xi{fIndex}(((size(xi{fIndex}, 1)-k)/2)+1:end-((size(xi{fIndex}, 1)-k)/2), ((size(xi{fIndex}, 2)-l)/2)+1:end-((size(xi{fIndex}, 2)-l)/2));
end

% compute embedding costs \rho
% xi{1} = imfilter(xi{1}, (1/9)*ones(3, 3), 'symmetric', 'conv', 'same');
% xi{2} = imfilter(xi{2}, (1/9)*ones(3, 3), 'symmetric', 'conv', 'same');
% xi{3} = imfilter(xi{3}, (1/9)*ones(3, 3), 'symmetric', 'conv', 'same');
% 
% xi{1} = medfilt2(xi{1},[3,3],'symmetric');
% xi{2} = medfilt2(xi{2},[3,3],'symmetric');
% xi{3} = medfilt2(xi{3},[3,3],'symmetric');
rho = xi{1} + xi{2} + xi{3};
% rho = medfilt2(rho,[3,3],'symmetric');
% rho = imfilter(rho, (1/9)*ones(3, 3), 'symmetric', 'conv', 'same');
% rho = imfilter(rho, (1/225)*ones(15, 15), 'symmetric', 'conv', 'same');
% rho = medfilt2(rho,[15,15],'symmetric');

% adjust embedding costs
rho(rho > wetCost) = wetCost; % threshold on the costs
rho(isnan(rho)) = wetCost; % if all xi{} are zero threshold the cost
rhoP1 = rho;
rhoM1 = rho;
rhoP1(cover==255) = wetCost; % do not embed +1 if the pixel has max value
rhoM1(cover==0) = wetCost; % do not embed -1 if the pixel has min value
rhoP1 = reshape(rhoP1,1,size(rhoP1,1)*size(rhoP1,2));
rhoM1 = reshape(rhoM1,1,size(rhoM1,1)*size(rhoM1,2));
rho0 = single(zeros(1,size(rhoP1,2)));


end