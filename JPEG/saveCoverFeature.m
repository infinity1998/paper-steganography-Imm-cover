%% Extract DCTR feature
clear all;
root_cover = 'Uimmcover_qf75\';
quality_factor = 75;
for i=1:10000
    imagePath = [root_cover,num2str(i),'.jpg'];
    I_STRUCT = jpeg_read(imagePath);
    F = DCTR(I_STRUCT, quality_factor); %DCTR extract
    cover.names{i,1} = [num2str(i),'.jpg'];
    cover.F(i,:) = F;
    fprintf('%f\n',i); 
end
save('Steganalysis_Feature\cover.mat','cover');

%% Extract GFR feature
% clear all;
% root_cover = 'Uimmcover_qf75\';
% quality_factor = 75;
% 
% for i=1:10000
%     imagePath = [root_cover,num2str(i),'.jpg'];
%     F = GFR(imagePath,32,quality_factor) ;
%     cover.names{i,1} = [num2str(i),'.jpg'];
%     cover.F(i,:) = F;
%     fprintf('%f\n',i); 
% end
% save('Steganalysis_Feature\cover.mat','cover');