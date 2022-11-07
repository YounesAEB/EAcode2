classdef StrainStressComputer < handle

    properties (Access = public)
        eps
        sig
    end

    properties (Access=private)
        data
        dimensions
        displ
        DOFsConnectivity
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computeSS();
        end
    end

    methods (Access=private)
        function init(obj, cParams)
            obj.data=cParams.data;
            obj.dimensions=cParams.dimensions;
            obj.DOFsConnectivity=cParams.DOFsConnectivity;
            obj.displ=cParams.displ;
        end
        function obj = computeSS(obj)%n_d,n_nod,n_el,u,Td,x,Tn,mat,Tmat)
            
            n_el=obj.dimensions.numElements;
            n_el_dof = obj.dimensions.numDOFsElement;
            c.nodalConnectivity=obj.data.nodalConnectivity;
            c.nodalCoordinates=obj.data.nodalCoordinates;
            u=obj.displ;
            Td=obj.DOFsConnectivity;
            mat=obj.data.materialProperties;
            Tmat=obj.data.materialConnectivity;
            
            ue = zeros(n_el_dof,1);
            obj.sig = zeros(n_el,1);
            obj.eps = zeros(n_el,1);
            
            for e=1:n_el
                c.e=e;%
                l=ElementsLengthAndRotationMatrixComputer(c);
                l.compute();
                le=l.elemLength;
                Re=l.RotationMatrix;%
                      
                for i = 1:n_el_dof
                    I = Td(e,i);  
                    ue(i,1) = u(I,1);
                end 
            
                ueprima =Re*ue; %Desplaçament en coordenades locals
                epsilone = (1/le)*[-1 1]*ueprima; %Deformació de la barra e
                Ee = mat(Tmat(e),1); %Mòdul de Young de la barra e                
                sigmae = Ee*epsilone; %Tensió de la barra e
            
                obj.sig(e,1) = sigmae;
                obj.eps(e,1) = epsilone;
            end
        end
    end
end