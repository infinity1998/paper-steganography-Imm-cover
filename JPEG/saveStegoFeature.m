%% Extract DCTR feature
clear all;
root_stego = 'stego\';
quality_factor = 75;
for i=1:10000
    imagePath = [root_stego,num2str(i),'.jpg'];
    I_STRUCT = jpeg_read(imagePath);
    F = DCTR(I_STRUCT, quality_factor); %DCTR extract
    stego.names{i,1} = [num2str(i),'.jpg'];
    stego.F(i,:) = F;
    fprintf('%f\n',i); 
end
save('Steganalysis_Feature\stego.mat','stego');

%% Extract GFR feature
% clear all;
% root_stego = 'stego\';
% quality_factor = 75;
% 
% for i=1:10000
%     imagePath = [root_stego,num2str(i),'.jpg'];
%     F = GFR(imagePath,32,quality_factor) ;
%     stego.names{i,1} = [num2str(i),'.jpg'];
%     stego.F(i,:) = F;
%     fprintf('%f\n',i); 
% end
% save('Steganalysis_Feature\stego.mat','stego');