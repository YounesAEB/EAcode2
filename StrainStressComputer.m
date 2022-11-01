classdef StrainStressComputer < handle

    properties
        eps
        sig
        sigBuckling
    end

    properties (Access=private)
        data
        dimensions
        displ
        DOFsConnectivity
        elemLong
    end

    methods
        function obj = StrainStressComputer(cParams)
            obj.data=cParams.data;
            obj.dimensions=cParams.dimensions;
            obj.DOFsConnectivity=cParams.DOFsConnectivity;
            obj.elemLong=cParams.elemLong;
            obj.displ=cParams.displ;
        end
        function compute(obj)
            obj.computeSS();
            obj.buckling();
        end

    end

    methods (Access=private)
        function obj = computeSS(obj)%n_d,n_nod,n_el,u,Td,x,Tn,mat,Tmat)
            
            n_el=obj.dimensions.numElements;
            n_el_dof = obj.dimensions.numDOFsElement;
            Tn=obj.data.nodalConnectivities;
            x=obj.data.nodalCoordinates;
            u=obj.displ;
            Td=obj.DOFsConnectivity;
            mat=obj.data.materialProperties;
            Tmat=obj.data.materialConnectivity;
            
            ue = zeros(n_el_dof,1);
            obj.sig = zeros(n_el,1);
            obj.eps = zeros(n_el,1);
            
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
                Ee = mat(Tmat(e),1);
                %Tensió de la barra e
                sigmae = Ee*epsilone;
            
                %Vectors de tensions ideformacions 
                obj.sig(e,1) = sigmae;
                obj.eps(e,1) = epsilone;
            end
        end
        function obj=buckling(obj)

            leb=obj.elemLong;
            mat=obj.data.materialProperties;
            Tmat=obj.data.materialConnectivity;
            n_el=obj.dimensions.numElements;

            sigbuck = zeros(n_el,1); 

            for e = 1:n_el
             sigbuck(e,1) = (pi^2)*mat(Tmat(e),1)*mat(Tmat(e),3)/(((leb(e,1)*1000)^2)*mat(Tmat(e),2));
            end 

            obj.sigBuckling=sigbuck;
        end
    end
end