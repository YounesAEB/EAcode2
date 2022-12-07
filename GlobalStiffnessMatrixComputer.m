classdef GlobalStiffnessMatrixComputer < handle

    properties (Access=public)
        globalK
    end

    properties (Access=private)
        elementalK
        initialData
        dimensions
        DOFsConnectivity
        elemLength
        rotationMatrix
    end

    methods (Access = public)
        function obj = GlobalStiffnessMatrixComputer(cParams)  
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeElementalStiffness();
            obj.assemblyStiffnessMatrix();
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions  =   cParams.dimensions;
            obj.initialData =   cParams.initialData;
            obj.DOFsConnectivity = cParams.DOFsConnectivity;
        end

        function computeElementalStiffness(obj)
            nElem                =   obj.dimensions.numElements;
            nElemDOF             =   obj.dimensions.numDOFsElement;
            materialProp         =   obj.initialData.materialProperties;
            materialConnect      =   obj.initialData.materialConnectivity;

            Kelem       =   zeros(nElemDOF, nElemDOF, nElem);
            for e=1:nElem
                iElem=e;
                obj.computeElementLength(iElem);
                obj.computeRotationMatrix(iElem);

                le   =    obj.elemLength;
                Re   =    obj.rotationMatrix;
                youngModulus = materialProp(materialConnect(e),1);
                Area = materialProp(materialConnect(e),2);

                Kelprima = youngModulus*Area/(le)*[1 -1; -1 1];
                Kelem(:,:,e) = Re.'*Kelprima*Re;
            end
            obj.elementalK=Kelem;
        end

        function computeElementLength(obj,iElem)
            c.nodalConnectivity = obj.initialData.nodalConnectivity;
            c.nodalCoordinates  = obj.initialData.nodalCoordinates;
            c.iElem             = iElem;
            l  = ElementsLengthComputer(c);
            l.compute();
            obj.elemLength = l.elemLength;
        end

        function computeRotationMatrix(obj,iElem)
            c.nodalConnectivity = obj.initialData.nodalConnectivity;
            c.nodalCoordinates  = obj.initialData.nodalCoordinates;
            c.iElem             = iElem;
            r  = RotationMatrixComputer(c);
            r.compute();
            obj.rotationMatrix = r.rotationMatrix;
        end

        function assemblyStiffnessMatrix(obj)
            obj.globalK   =   zeros(obj.dimensions.numDOFsTotal);
            Td          =   obj.DOFsConnectivity;
            for e=1:obj.dimensions.numElements
                for i=1:obj.dimensions.numDOFsElement
                    I = Td(e,i);
                    for j = 1:obj.dimensions.numDOFsElement
                        J = Td(e,j);
                        obj.globalK(I,J) = obj.globalK(I,J)+obj.elementalK(i,j,e);
                    end
                end
            end
        end

    end
end