clear all;
root_cover = '\';
for i = 1:10
    cover = double(imread([root_cover,num2str(i),'.pgm']));
    [cover_noise] = AIS_f(cover,0.5,0.4);
end 

