function cost_block = UIPRSelection(image,NR)
avr_residuals = MyGabor_filter(image,NR);
complex_block = zeros(32,32);
for block_R_M = 1:32
    for block_R_N = 1:32
        complex_block(block_R_M,block_R_N)  = sum(sum(avr_residuals((block_R_M-1)*8+1:block_R_M*8,(block_R_N-1)*8+1:block_R_N*8)));      
    end
end
cost_block = 1./complex_block;
x = imresize(complex_block,8,'nearest'); 
end

