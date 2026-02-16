%% generate stego JPEG 

clear all;
root_cover = 'Uimmcover_qf75\';
save_stego = 'stego\';
payload = 0.4;
for i = 1:10000
    coverPath = [root_cover,num2str(i),'.jpg'];
    stegoPath = [save_stego,num2str(i),'.jpg'];
    S_STRUCT = J_UNIWARD(coverPath, payload);
    jpeg_write(S_STRUCT, stegoPath);
    fprintf('Generate stego(C60-JUNI02): %d\n',i);
end