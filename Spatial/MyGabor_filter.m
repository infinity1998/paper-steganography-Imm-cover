function avr_residuals = MyGabor_filter(IMAGE,NR)
Rotations = (0:NR-1)*pi/NR;
sr=numel(Rotations); %theta

% Standard deviations
Sigma = [0.5 0.75 1 1.25]; %delta
ss=numel(Sigma);
PhaseShift = [0 pi/2]; %fai
sp=numel(PhaseShift);
AspectRatio = 0.5; %gama
I_spatial = IMAGE;

% Load Gabor Kernels
Kernel = cell(ss,sr,sp);
for S = Sigma
    for R = Rotations
        for P=PhaseShift
        Kernel{S==Sigma,R==Rotations,P==PhaseShift} = gaborkernel(S, R, P, AspectRatio);
        end
    end
end

residuals = zeros(size(I_spatial));
sizeCover=size(I_spatial);
for mode_P=1:sp
    for mode_S = 1:ss  
        for mode_R = 1:sr  
            filters = Kernel{mode_S,mode_R,mode_P};
            padsize=max(size(filters));
            coverPadded = padarray(I_spatial, [padsize padsize], 'symmetric');% add padding
            residual = conv2(coverPadded, filters, 'same');
            W1 = abs(residual);                  
            if mod(size(filters, 1), 2) == 0, W1= circshift(W1, [1, 0]); end;
            if mod(size(filters, 2), 2) == 0, W1 = circshift(W1, [0, 1]); end;
            W1 = W1(((size(W1, 1)-sizeCover(1))/2)+1:end-((size(W1, 1)-sizeCover(1))/2), ((size(W1, 2)-sizeCover(2))/2)+1:end-((size(W1, 2)-sizeCover(2))/2));
            residuals = residuals + W1;
        end      
    end       
end
avr_residuals =  residuals/(sp*ss*sr);

end

function kernel = gaborkernel(sigma, theta, phi, gamma)
lambda = sigma / 0.56;
gamma2 = gamma^2;
s = 1 / (2*sigma^2);
f = 2*pi/lambda;
% sampling points for Gabor function
[x,y]=meshgrid([-7/2:-1/2,1/2:7/2],[-7/2:-1/2,1/2:7/2]);
y = -y;
xp =  x * cos(theta) + y * sin(theta);
yp = -x * sin(theta) + y * cos(theta);
kernel = exp(-s*(xp.*xp + gamma2*(yp.*yp))) .* cos(f*xp + phi);
% normalization
kernel = kernel- sum(kernel(:))/sum(abs(kernel(:)))*abs(kernel);
end