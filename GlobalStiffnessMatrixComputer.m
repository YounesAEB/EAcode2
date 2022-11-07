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
        function obj = GlobalStiffnessMatrixComputer(cParams)  
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.DOFsConnectivityComputer();
            obj.computekElem();
            obj.assemblyKG();
        end
    end

    methods (Access=private)
        function init(obj,cParams)
            obj.dimensions  =   cParams.dimensions;
            obj.data        =   cParams.data;
        end

        function DOFsConnectivityComputer(obj)
            Td      =   zeros(obj.dimensions.numElements, obj.dimensions.numDOFsElement);
            Tnod    =   obj.data.nodalConnectivity;
            nd      =   obj.dimensions.numDimensions;

            for i=1:obj.dimensions.numElements
                Td(i,1)=Tnod(i,1)*nd-2;
                Td(i,2)=Tnod(i,1)*nd-1;
                Td(i,3)=Tnod(i,1)*nd;
                Td(i,4)=Tnod(i,2)*nd-2;
                Td(i,5)=Tnod(i,2)*nd-1;
                Td(i,6)=Tnod(i,2)*nd;
            end
            obj.DOFsConnectivity    =   Td;
        end

        function computekElem(obj)
            n_el        =   obj.dimensions.numElements;
            n_el_dof    =   obj.dimensions.numDOFsElement;
            mat         =   obj.data.materialProperties;
            Tmat        =   obj.data.materialConnectivity;
            c.nodalConnectivity      =   obj.data.nodalConnectivity;
            c.nodalCoordinates  = obj.data.nodalCoordinates;

            Kelem       =   zeros(n_el_dof, n_el_dof, n_el);
            for e=1:n_el
                c.e=e;%
                l=ElementsLengthAndRotationMatrixComputer(c);
                l.compute();
                le=l.elemLength;
                Re=l.RotationMatrix;%
                Kelprima =(mat(Tmat(e),1)*mat(Tmat(e),2))/(le)*[1 -1; -1 1];
                Kelem(:,:,e) = Re.'*Kelprima*Re;
            end
            obj.kElem=Kelem;
        end

        function assemblyKG(obj)
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