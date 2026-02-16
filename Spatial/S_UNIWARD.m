function [stego] = S_UNIWARD(cover, payload)
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
%% Embedding simulator
[~,~,P2] = EmbeddingSimulator(cover, rhoP1, rhoM1, payload*numel(cover), true);
% P2x = medfilt2(P2,[15,15],'symmetric');
% P2x = adpmedian(P2,7);
% P2x = imfilter(P2, (1/9)*ones(3, 3), 'symmetric', 'conv', 'same');
P2x = imfilter(P2, (1/1)*ones(1, 1), 'symmetric', 'conv', 'same');

P2x(P2x>2/3) = 2/3;

rhoP1Turn = log((1-P2x)./(P2x/2));%概率翻转为失真
rhoM1Turn = log((1-P2x)./(P2x/2));
rhoP1Turn(rhoP1Turn > wetCost) = wetCost;
rhoP1Turn(isnan(rhoP1Turn)) = wetCost; 
rhoM1Turn(rhoM1Turn > wetCost) = wetCost;
rhoM1Turn(isnan(rhoM1Turn)) = wetCost;
rhoP1Turn(cover==255) = wetCost;
rhoM1Turn(cover==0) = wetCost;

[stego,pChangeP1] = EmbeddingSimulator(cover, rhoP1Turn, rhoM1Turn, payload*numel(cover), true);
% save('D:\SteganographyCode\BOSSbase_1.01(512@512)\512@512P\299p.mat','pChangeP1');
%% --------------------------------------------------------------------------------------------------------------------------
% Embedding simulator simulates the embedding made by the best possible ternary coding method (it embeds on the entropy bound). 
% This can be achieved in practice using "Multi-layered  syndrome-trellis codes" (ML STC) that are asymptotically aproaching the bound.
function [y,pChangeP1,P2] = EmbeddingSimulator(x, rhoP1, rhoM1, m, fixEmbeddingChanges)
    n = numel(x);   
    lambda = calc_lambda(rhoP1, rhoM1, m, n);
    pChangeP1 = roundn((exp(-lambda .* rhoP1))./(1 + exp(-lambda .* rhoP1) + exp(-lambda .* rhoM1)),-5);
    pChangeM1 = roundn((exp(-lambda .* rhoM1))./(1 + exp(-lambda .* rhoP1) + exp(-lambda .* rhoM1)),-5);
    P2 = pChangeP1 + pChangeM1;
%     figure;
%     imshow(pChangeP1,[]);title('SUNIWARD');
%     figure;
%     imhist(pChangeP1);xlabel({' ','概率'});ylabel('像素数量');title('SUNIWARD的概率分布');
    if fixEmbeddingChanges == 1
        RandStream.setGlobalStream(RandStream('mt19937ar','seed',139187));
    else
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock)));
    end
    randChange = rand(size(x));
    y = x;
    y(randChange < pChangeP1) = y(randChange < pChangeP1) + 1;
    y(randChange >= pChangeP1 & randChange < pChangeP1+pChangeM1) = y(randChange >= pChangeP1 & randChange < pChangeP1+pChangeM1) - 1;
    
    function lambda = calc_lambda(rhoP1, rhoM1, message_length, n)

        l3 = 1e+3;
        m3 = double(message_length + 1);
        iterations = 0;
        while m3 > message_length
            l3 = l3 * 2;
            pP1 = (exp(-l3 .* rhoP1))./(1 + exp(-l3 .* rhoP1) + exp(-l3 .* rhoM1));
            pM1 = (exp(-l3 .* rhoM1))./(1 + exp(-l3 .* rhoP1) + exp(-l3 .* rhoM1));
            m3 = ternary_entropyf(pP1, pM1);
            iterations = iterations + 1;
            if (iterations > 10)
                lambda = l3;
                return;
            end
        end        
        
        l1 = 0; 
        m1 = double(n);        
        lambda = 0;
        
        alpha = double(message_length)/n;
        % limit search to 30 iterations
        % and require that relative payload embedded is roughly within 1/1000 of the required relative payload        
        while  (double(m1-m3)/n > alpha/1000.0 ) && (iterations<30)
            lambda = l1+(l3-l1)/2; 
            pP1 = (exp(-lambda .* rhoP1))./(1 + exp(-lambda .* rhoP1) + exp(-lambda .* rhoM1));
            pM1 = (exp(-lambda .* rhoM1))./(1 + exp(-lambda .* rhoP1) + exp(-lambda .* rhoM1));
            m2 = ternary_entropyf(pP1, pM1);
    		if m2 < message_length
    			l3 = lambda;
    			m3 = m2;
            else
    			l1 = lambda;
    			m1 = m2;
            end
    		iterations = iterations + 1;
        end
    end
    
    function Ht = ternary_entropyf(pP1, pM1)
        p0 = 1-pP1-pM1;
        P = [p0(:); pP1(:); pM1(:)];
        H = -((P).*log2(P));
        H((P<eps) | (P > 1-eps)) = 0;
        Ht = sum(H);
    end
end
end