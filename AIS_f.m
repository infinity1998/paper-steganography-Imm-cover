function [cover_noise] = AIS_f(cover,gamma,delta)
NR=12;
cost_block = UIPRSelection(cover,NR);
select_block = zeros(32,32);
T = selectT(cost_block,gamma);
select_block(cost_block<=T)=1;
select_block_r = imresize(select_block,8,'nearest'); 
select_block_r = reshape(select_block_r,size(cover,1)*size(cover,2),1);
textureResidual = round(UIPIntensity(cover).*delta);
textureResidual = reshape(textureResidual,size(cover,1)*size(cover,2),1);

N = size(cover,1)*size(cover,2);                    
NP = 30;             
G = 10;                                           
Range = [-textureResidual,textureResidual];

for i = 1:NP
    rng('shuffle');
    f(:,i) = round(Range(:,1) + (Range(:,2) - Range(:,1)).*rand(N,1).*select_block_r); 
end
len=zeros(1,NP);                                 
for i=1:NP 
    len(:,i) = fitness_func(f(:,i), cover);
end

[~,Index]=sort(len,'descend');             
Sortf=f(:,Index);                                
gen = 0;                                       
Nc1= 4;                                 

while gen < G
    for i=1:floor(NP/10)        
        a=Sortf(:,i);         
        Ca=repmat(a,1,Nc1);                
        for j = 1:Nc1
            rng('shuffle');
            sigma = textureResidual.*0.5;
            tmp = round(normrnd(Ca(:,j), sigma));
            tmp = max(tmp,Range(:,1));
            tmp = min(tmp,Range(:,2));
            Ca(:,j) = tmp;
        end    
        Ca(:,1)=Sortf(:,i);                
        for j=1:Nc1
           Calen(j,:) = fitness_func(Ca(:,j), cover);       
        end
        [SortCalen,Index1]=sort(Calen,'descend'); 
        SortCa=Ca(:,Index1);      
        af(:,i)=SortCa(:,1);
        alen(i)=SortCalen(1);
    end   
    for i = 1:NP-floor(NP/4)
        rng('shuffle');
        bf(:,i) = round(Range(:,1) + (Range(:,2) - Range(:,1)).*rand(N,1));
        blen(i) = fitness_func(bf(:,i), cover);
    end
    f=[af,bf]; 
    len=[alen,blen];
    [Sortlen,Index]=sort(len,'descend');
    Sortf=f(:,Index);
    gen=gen+1;

end  
fprintf('FINISH\n');    
Bestf=reshape(Sortf(:,1),size(cover,1),size(cover,2));
cover_noise = cover + Bestf;
cover_noise(cover_noise>255) = 255;
cover_noise(cover_noise<0) = 0;

end

function [T] = selectT(array,a)
s = sort(reshape(array,1,size(array,1)*size(array,2)));
T = s(1,round(size(array,1)*size(array,2)*a));
end
