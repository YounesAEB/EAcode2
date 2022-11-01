classdef Data < handle

    properties (Access=public)
        nodalCoordinates
        nodalConnectivities
        fixNod
        forcesData
        materialProperties
        materialConnectivity
    end

    methods (Access=public, Static)
        function obj = setData(cParams) % No és un constructor

            obj.nodalCoordinates=[0 0 0; 0 1 0;0 1 1; 0 0 1; 1 1/2 1/2];
            obj.nodalConnectivities = [1 5; 2 5; 3 5; 4 5];
            obj.fixNod=[1 1 0;1 2 0;1 3 0; 2 1 0;2 2 0;2 3 0;3 1 0;3 2 0;3 3 0;4 1 0;4 2 0;4 3 0;];
            obj.forcesData= [5 3 -cParams.F];
            obj.materialProperties=[cParams.Young cParams.Area cParams.Inertia];
            obj.materialConnectivity=ones(1,4);

        end
    end
end