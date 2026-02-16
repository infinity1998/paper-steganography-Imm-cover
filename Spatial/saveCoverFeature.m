clear all;
root_cover = 'Uimmcover\';

for i = 1:10000
    cover_image = imread([root_cover,num2str(i),'.pgm']);
    cover_image = single(cover_image);
    cover.names{i,1} = [num2str(i),'.pgm'];
    cover.F(i,:) = SubmodelConcatenation(SRM([root_cover,num2str(i),'.pgm']));
    
    fprintf('SRM:%f\n',i); 
end
save('Steganalysis_Feature\cover.mat','cover');