clear all;
root_cover = 'BOSSBase_cover_256\';
root_Uimm_cover = 'Uimmcover\';
run('config.m');

for i = 1:10000
    cover = double(imread([root_cover,num2str(i),'.pgm']));
    [cover_noise] = AIS_f(cover,gamma,delta,NP,G,Nc1,e,Isr,QualityFactor);
    imwrite(uint8(cover_noise),[root_Uimm_cover,num2str(i),'.pgm']);
end 

