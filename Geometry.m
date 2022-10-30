classdef Geometry

    properties
        numElements
        L
    end

    methods
        function obj = Geometry(cParams)
            obj.numElements = cParams.e;
            obj.L=cParams.L;
        end

        function nodalCoordinates = creationMatrixNodalCoordinates(obj)
            nodalCoordinates=[0 0 0; 0 obj.L 0;0 obj.L obj.L; 0 0 obj.L; obj.L obj.L/2 obj.L/2];
        end

    end

    methods (Access=public, Static)
        function connectivityMatrix = creationConnectivityMatrix()
            connectivityMatrix = [1 5; 2 5; 3 5; 4 5];
        end

        function fixNod= creationFixNodesMatrix()
            fixNod=[1 1 0;1 2 0;1 3 0; 2 1 0;2 2 0;2 3 0;3 1 0;3 2 0;3 3 0;4 1 0;4 2 0;4 3 0;];
        end

         function Fdata= ExternalForceMatrixCreation(F)
            Fdata = [5 3 -F];
        end
    end
end