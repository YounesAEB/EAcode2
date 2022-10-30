classdef Material
    properties
        youngModulus
        section  %diferents materials, diferent secció, en general
        Inertia
    end

    methods
        function obj = Material(cParams)
            obj.youngModulus = cParams.Young;
            obj.section=cParams.Area;
            obj.Inertia=cParams.Inertia;
        end

        function materialConnectivity = creationMaterialConnectivity(obj,numElements)
            warning('pq cal posar obj????, sense ell em diu que too many input arguments. [Material class, line 15]. El mateix em passa amb la funció ExternalForceMatrixCreation de Geometry class, tot i que en aquest cas sha solucionat fent la funció estàtica.')
            materialConnectivity = ones(1,numElements);
        end

        function [Kelem,leb]=computeKelBar(obj,n_el,n_el_dof,x,Tnod,mat,Tmat)
            Kelem=zeros(n_el_dof, n_el_dof, n_el);
            leb = zeros(n_el,1);
            for e=1:n_el
                x1e=x(Tnod(e,1),1);
                y1e=x(Tnod(e,1),2);
                z1e=x(Tnod(e,1),3);
                x2e=x(Tnod(e,2),1);
                y2e=x(Tnod(e,2),2);
                z2e=x(Tnod(e,2),3);
                le=sqrt((x2e-x1e)^2+(y2e-y1e)^2+(z2e-z1e)^2);
                
                Re = 1/le*[x2e-x1e y2e-y1e z2e-z1e 0 0 0;
                           0 0 0 x2e-x1e y2e-y1e z2e-z1e];
                
                Kelprima =(mat.section*mat.youngModulus)/(le)*[1 -1; -1 1];
                Kelem(:,:,e) = Re.'*Kelprima*Re;
                leb(e,1)= le;
            end
        end

    end
end
