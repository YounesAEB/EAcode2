function [u,R,KLL,KRR,KRL,KLR,FL,FR] = solveSys_t(vL,vR,uR,KG,Fext)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

%Obtenció de les particions
%Matriu KRR
KRR = zeros(numel(vR),numel(vR));
for i = 1:numel(vR)
    for j = 1:numel(vR)
        KRR(i,j)=KG(vR(i),vR(j));  
    end
end   
%Matriu KRL
KRL = zeros(numel(vR),numel(vL));
for i = 1:numel(vR)
    for j = 1:numel(vL)
        KRL(i,j)=KG(vR(i),vL(j));  
    end
end
    
%Matriu KLR
KLR = zeros(numel(vL),numel(vR));
for i = 1:numel(vL)
    for j = 1:numel(vR)
        KLR(i,j)=KG(vL(i),vR(j));   
    end
end

%Matriu KLL
KLL = zeros(numel(vL),numel(vL));
for i = 1:numel(vL)
    for j = 1:numel(vL)
        KLL(i,j)=KG(vL(i),vL(j));
    end
end
    
%Vector FL
FL = zeros(numel(vL),1);
for i = 1:numel(vL)
   FL(i,1)=Fext(vL(i),1);
end 

%Vector FR
FR = zeros(numel(vR),1);
for i = 1:numel(vR)
   FR(i,1)=Fext(vR(i),1);
end 

%Obtenció de les variables a calcular
uL = KLL\(FL-KLR*uR);
R = KRR*uR+KRL*uL-FR;

%Obtenció del vector u amb tots els desplaçaments
u = zeros(numel(vL)+numel(vR),1);
for i = 1:numel(vR)
    u(vR(i),1) = uR(i,1);
end
for i = 1:numel(vL)
    u(vL(i),1) = uL(i,1) ;
end

end


