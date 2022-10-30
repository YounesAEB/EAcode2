classdef Solver < handle
    
    properties
        A
        b
    end

    methods (Access=public, Static)
        function obj = create(cParams) %esto NO se puede hacer como un constructor normal, sino como una función.
          switch cParams.type
              case 'direct'
                  obj = directSolver(cParams);
              case 'iterative'
                  obj = iterativeSolver(cParams);
          end
        end

        function [vL,vR,uR] = applyCond(n_dof,fixNod)
            vR=zeros(size(fixNod,1),1);
            uR=ones(size(fixNod,1),1);
            
            for i=1:size(fixNod,1)    
                if fixNod(i,2)==1
                   vR(i)=3*fixNod(i,1)-2;
                   uR(i)=fixNod(i,3);
                end
            
                if fixNod(i,2)==2
                   vR(i)=3*fixNod(i,1)-1;
                   uR(i)=fixNod(i,3);
                end
                
                if fixNod(i,2)==3
                   vR(i)=3*fixNod(i,1);
                   uR(i)=fixNod(i,3);
                end
            end
            
            vL=zeros(n_dof-size(fixNod,1),1);
            
            suma=1;
            for i=1:n_dof
                cont=0;
                for j=1:size(vR)
                    if i==vR(j)
                       cont=cont+1;
                    end
                end
                if cont==0 
                   vL(suma)=i;
                   suma=suma+1;
                end
            end
        end

        function [KRR,KRL,KLR,KLL,FL,FR]=partitionK(vL,vR,KG,Fext)
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
        end

        function [u,R]=displacementObtention(cParams,uR,vL,vR,uL)
            R = cParams.KRR*cParams.uR+cParams.KRL*uL-cParams.FR;
            %Obtenció del vector u amb tots els desplaçaments
            u = zeros(numel(vL)+numel(vR),1);
            for i = 1:numel(vR)
                u(vR(i),1) = uR(i,1);
            end
            for i = 1:numel(vL)
                u(vL(i),1) = uL(i,1) ;
            end
        end

        function [eps,sig]=computeStrainStressBar(n_d,n_nod,n_el,u,Td,x,Tn,mat,Tmat)
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
                Ee = mat.youngModulus;
                %Tensió de la barra e
                sigmae = Ee*epsilone;
            
                %Vectors de tensions ideformacions 
                sig(e,1) = sigmae;
                eps(e,1) = epsilone;
            end
        end

        function sigbuck=buckling(leb,mat,Tmat,n_el)
            sigbuck = zeros(n_el,1);        
            for e = 1:n_el
             sigbuck(e,1) = (pi^2)*mat.youngModulus*mat.Inertia/(((leb(e,1)*1000)^2)*mat.section);
            end    
        end

    end
end

            


