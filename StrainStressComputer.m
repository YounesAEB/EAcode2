classdef StrainStressComputer < handle

    properties (Access = public)
        strain
        stress
    end

    properties (Access=private)
        nodalCoordinates
        nodalConnectivity
        materialProperties
        materialConnectivity
        dimensions
        displ
        DOFsConnectivity
        elemLength
        rotationMatrix
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computeStrainStress();
        end
    end

    methods (Access = private)
        function init(obj, cParams)
            obj.materialProperties  =   cParams.materialProperties;
            obj.materialConnectivity =  cParams.materialConnectivity;
            obj.nodalConnectivity   =   cParams.nodalConnectivity;
            obj.nodalCoordinates    =   cParams.nodalCoordinates;
            obj.dimensions          =   cParams.dimensions;
            obj.DOFsConnectivity    =   cParams.DOFsConnectivity;
            obj.displ               =   cParams.displ;
        end

        function obj = computeStrainStress(obj)      
            nElem               =   obj.dimensions.numElements;
            mat                 =   obj.materialProperties;
            Tmat                =   obj.materialConnectivity;
            
            obj.stress = zeros(nElem,1);
            obj.strain = zeros(nElem,1);
            
            for e=1:nElem
                iElem = e;
                obj.computeElementLength(iElem);
                obj.computeRotationMatrix(iElem);
                globalCoordDispl = obj.computeGlobalCoordDisplacements(iElem);

                le = obj.elemLength;
                Re = obj.rotationMatrix;
            
                localCoordDispl      =   Re*globalCoordDispl; 
                deformationElem =   (1/le)*[-1 1]*localCoordDispl; 
                youngModulus    =   mat(Tmat(e),1);                
                stressElem      =   youngModulus*deformationElem; 
            
                obj.stress(e,1) = stressElem;
                obj.strain(e,1) = deformationElem;
            end
        end

        function computeElementLength(obj,iElem)
            c.nodalConnectivity = obj.nodalConnectivity;
            c.nodalCoordinates  = obj.nodalCoordinates;
            c.iElem             = iElem;
            l  = ElementsLengthComputer(c);
            l.compute();
            obj.elemLength = l.elemLength;
        end

        function computeRotationMatrix(obj,iElem)
            c.nodalConnectivity = obj.nodalConnectivity;
            c.nodalCoordinates  = obj.nodalCoordinates;
            c.iElem             = iElem;
            r  = RotationMatrixComputer(c);
            r.compute();
            obj.rotationMatrix = r.rotationMatrix;
        end

        function globalCoordDispl = computeGlobalCoordDisplacements(obj,iElem)
            nElemDOFs   =   obj.dimensions.numDOFsElement;
            u           =   obj.displ;
            Td          =   obj.DOFsConnectivity;
            
            globalCoordDispl = zeros(nElemDOFs,1);
            for i = 1:nElemDOFs
                I = Td(iElem,i);  
                globalCoordDispl(i,1) = u(I,1);
            end 
        end

    end
end