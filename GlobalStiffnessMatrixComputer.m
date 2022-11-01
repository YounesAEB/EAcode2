classdef GlobalStiffnessMatrixComputer < handle

    properties (Access=public)
        kElem
        kGlob
        elementsLong
        DOFsConnectivity
    end

    properties (Access=private)
        data
        dimensions
    end

    methods (Access=public)
        function obj = GlobalStiffnessMatrixComputer(c)  
            obj.dimensions=c.dimensions;
            obj.data=c.data;
        end

        function obj = compute(obj)
            obj=obj.DOFsConnectivityComputer();
            obj=obj.computekElem();
            obj=obj.assemblyKG();
        end
    end

    methods (Access=private)
        function obj=DOFsConnectivityComputer(obj)
            Td = zeros(obj.dimensions.numElements, obj.dimensions.numDOFsElement);
            Tnod=obj.data.nodalConnectivities;
            for i=1:obj.dimensions.numElements
                Td(i,1)=Tnod(i,1)*obj.dimensions.numDimensions-2;
                Td(i,2)=Tnod(i,1)*obj.dimensions.numDimensions-1;
                Td(i,3)=Tnod(i,1)*obj.dimensions.numDimensions;
                Td(i,4)=Tnod(i,2)*obj.dimensions.numDimensions-2;
                Td(i,5)=Tnod(i,2)*obj.dimensions.numDimensions-1;
                Td(i,6)=Tnod(i,2)*obj.dimensions.numDimensions;
            end
            obj.DOFsConnectivity=Td;
        end

        function obj=computekElem(obj)
            n_el=obj.dimensions.numElements;
            n_el_dof=obj.dimensions.numDOFsElement;
            x=obj.data.nodalCoordinates;
            Tnod=obj.data.nodalConnectivities;
            mat=obj.data.materialProperties;
            Tmat=obj.data.materialConnectivity;

            Kelem=zeros(n_el_dof, n_el_dof, n_el);
            obj.elementsLong = zeros(n_el,1);
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
                
                Kelprima =(mat(Tmat(e),1)*mat(Tmat(e),2))/(le)*[1 -1; -1 1];
                Kelem(:,:,e) = Re.'*Kelprima*Re;
                obj.elementsLong(e,1)= le;
            end
            obj.kElem=Kelem;
        end

        function obj = assemblyKG(obj)
            obj.kGlob=zeros(obj.dimensions.numDOFsTotal);
            Td=obj.DOFsConnectivity;
            for e=1:obj.dimensions.numElements
                for i=1:obj.dimensions.numDOFsElement
                    I=Td(e,i);
                    for j=1:obj.dimensions.numDOFsElement
                        J=Td(e,j);
                        obj.kGlob(I,J)=obj.kGlob(I,J)+obj.kElem(i,j,e);
                    end
                end
            end
        end
    end
end