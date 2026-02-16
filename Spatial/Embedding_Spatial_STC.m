%% embedding SUNIWARD_STC
clear all;
root_cover = 'Uimmcover\';
save_stego =  'stego_stc\';

for i = 1:10000
    stego_image = uint8(SUNIWARD_STC([root_cover,num2str(i),'.pgm'],0.4));
    imwrite(stego_image,[save_stego,num2str(i),'.pgm']);
    fprintf('SUNIWARD_STC (256@256):%f\n',i);
end
