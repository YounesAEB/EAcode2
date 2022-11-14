classdef Preprocess < handle

    properties (Access = public)
        nodalCoordinates
        nodalConnectivity
        fixNod
        forcesData
        materialProperties
        materialConnectivity
    end

    properties (Access = private)
        F
        area
        young
        inertia
        type
    end

    methods (Access=public)
        function obj = Preprocess (cParams)
            obj.init(cParams);
        end

        function setInitialData(obj)
            obj.setNodalCoord();
            obj.setNodalConnectiviy();
            obj.setFixedNodes();
            obj.setForcesMatrix();
            obj.setMaterialProperties();
            obj.setMaterialConnectivity();
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.F       =   cParams.F;
            obj.area    =   cParams.Area;
            obj.young   =   cParams.Young;
            obj.inertia =   cParams.Inertia;
        end

        function setNodalCoord(obj)
            obj.nodalCoordinates=[0 0 0; 0 1 0;0 1 1; 0 0 1; 1 1/2 1/2];
        end

        function setNodalConnectiviy(obj)
            obj.nodalConnectivity = [1 5; 2 5; 3 5; 4 5];
        end

        function setFixedNodes(obj)
            obj.fixNod=[1 1 0;1 2 0;1 3 0; 2 1 0;2 2 0;2 3 0;3 1 0;3 2 0;3 3 0;4 1 0;4 2 0;4 3 0;];
        end

        function setForcesMatrix(obj)
            obj.forcesData= [5 3 -obj.F];
        end

        function setMaterialProperties(obj)
            obj.materialProperties=[obj.young obj.area obj.inertia];
        end

        function setMaterialConnectivity(obj)
            obj.materialConnectivity=ones(1,4);
        end

        
    end
end