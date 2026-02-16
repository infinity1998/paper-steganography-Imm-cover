clear all;
root_stego = 'stego\';

for i = 1:10000
    stego_image = imread([root_stego,num2str(i),'.pgm']);
    stego_image = single(stego_image);
    stego.names{i,1} = [num2str(i),'.pgm'];
    stego.F(i,:) = SubmodelConcatenation(SRM([root_stego,num2str(i),'.pgm']));
    
    fprintf('SRM:%f\n',i); 
end
save('Steganalysis_Feature\stego.mat','stego');