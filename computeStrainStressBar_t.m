function [eps,sig] = computeStrainStressBar_t(n_d,n_nod,n_el,u,Td,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - eps   Strain vector [n_el x 1]
%            eps(e) - Strain of bar e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------
n_i = n_d;
n_el_dof = n_i*n_nod;
ue = zeros(n_el_dof,1);
sig = zeros(n_el,1);
eps = zeros(n_el,1);

%Rotation matrix

for e=1:n_el
    x1e=x(Tn(e,1),1);
    y1e=x(Tn(e,1),2);
    z1e=x(Tn(e,1),3);
    x2e=x(Tn(e,2),1);
    y2e=x(Tn(e,2),2);
    z2e=x(Tn(e,2),3);
    le=sqrt((x2e-x1e)^2+(y2e-y1e)^2+(z2e-z1e)^2);
    
    Re = 1/le*[x2e-x1e y2e-y1e z2e-z1e 0 0 0;
               0 0 0 x2e-x1e y2e-y1e z2e-z1e];
    
     
    for i = 1:n_el_dof
    I = Td(e,i);  
    ue(i,1) = u(I,1);
    end 

    %Desplaçament en coordenades locals
    ueprima =Re*ue;

    %Deformació de la barra e
    epsilone = (1/le)*[-1 1]*ueprima;

    %Mòdul de Young de la barra e
    Ee = mat(Tmat(e), 1);
    %Tensió de la barra e
    sigmae = Ee*epsilone;

    %Vectors de tensions ideformacions 
    sig(e,1) = sigmae;
    eps(e,1) = epsilone;
end

end