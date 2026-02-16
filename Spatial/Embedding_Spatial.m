%% generate stego Spatial SUNIWARD/WOW

clear all;
root_cover = 'Uimmcover\';
save_stego = 'stego\';
payload=0.4;
for i = 1:10000
    cover_image = imread([root_cover,num2str(i),'.pgm']);
    stego_image = uint8(S_UNIWARD(cover_image,payload));
    imwrite(stego_image,[save_stego,num2str(i),'.pgm']);
    if mod(i,100) == 0
        fprintf('«∂»ÎÕº∆¨(512@512)–Ú∫≈:%f\n',i);
    end
end