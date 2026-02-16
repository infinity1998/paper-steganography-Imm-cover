function [fitness] = fitness_func(f, cover ,QualityFactor)
randint_ab = reshape(f,size(cover,1),size(cover,2));  
cover_noise = cover + randint_ab;
cover_noise(cover_noise>255) = 255;
cover_noise(cover_noise<0) = 0;

imwrite(uint8(cover_noise),'j_ais_75_tt.jpg','Quality',QualityFactor);
j_ais_75_tt = jpeg_read('.\j_ais_75_tt.jpg');

dct_coef = j_ais_75_tt.coef_arrays{1};
dct_coef2 = dct_coef;
dct_coef2(1:8:end,1:8:end) = 0;
q_tab = j_ais_75_tt.quant_tables{1};
q_tab(1,1) = 0.5*(q_tab(2,1)+q_tab(1,2));
q_matrix = repmat(q_tab,[32 32]);
wi = [0;1;2;3;4;5;6;7]*[0,1,2,3,4,5,6,7];
wi_matrix = repmat(wi,[32 32]);
dct_coef2 = im2col((q_matrix.*dct_coef2).*wi_matrix,[8 8],'distinct');
fitness = sum(sum(abs(dct_coef2)));

end