function sigbuck = buckling(leb,mat,Tmat,n_el)
%BUCKLING Summary of this function goes here
%   Detailed explanation goes here

sigbuck = zeros(n_el,1);    
    
for e = 1:n_el
    
 sigbuck(e,1) = ((pi^2)*mat(Tmat(e),1)*mat(Tmat(e),4))  /(((leb(e,1)*1000)^2)*mat(Tmat(e),2));
    


end

