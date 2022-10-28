function [F0] = computeThermalEffect(n_d, n_el, n_i, x, Tn, Td, Tmat, mat, n_dof, deltaT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Re = zeros(2*n_d, 2*n_d, n_el); 
leb = zeros(n_el,1);

for e=1:n_el
    x1e=x(Tn(e,1),1);
    y1e=x(Tn(e,1),2);
    x2e=x(Tn(e,2),1);
    y2e=x(Tn(e,2),2);

    le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
    
    se=(y2e-y1e)/le;
    ce=(x2e-x1e)/le;
    
    Re(:,:,e)=[
        ce se 0 0;
        -se ce 0 0;
        0 0 ce se;
        0 0 -se ce;
        ];

    leb(e,1)= le;
end

eps0e=zeros(n_el,1);
F0el=zeros(4, n_el);

%local thermal forces
for i=1:n_el
    localdir=[-1 0 1 0];
    eps0e(i,1)=mat(Tmat(i),3)*deltaT; 
    F0el(:,i)=eps0e(i,1)*mat(Tmat(i),2)*mat(Tmat(i),1)*localdir;
end

%global thermal forces
F0e=zeros(4, n_el);
for i=1:n_el
    F0e(:,i)=(Re(:,:,i))\F0el(:,i);
end

%assembly F0e
F0=zeros(n_dof,1);
for i = 1:n_el
    for j = 1:(n_d*n_i)
        F0((Td(i,j)),1)=F0((Td(i,j)),1)+F0e(j,i);
    end
end

end