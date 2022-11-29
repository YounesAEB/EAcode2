classdef DOFsConnectivityComputer < handle

    properties (Access = public)
        DOFsConnectivity
    end

    properties (Access = private)
        nDim
        nElem
        nDOFsElem
        nodalConnectivity
    end

    methods (Access = public)
        function obj = DOFsConnectivityComputer(cParams)
            obj.init(cParams);
            obj.computeDOFsConnectivity();
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.nDim = cParams.nDim;
            obj.nElem = cParams.nElem;
            obj.nDOFsElem = cParams.nDOFsElem;
            obj.nodalConnectivity = cParams.nodalConnectivity;
        end
        
        function computeDOFsConnectivity(obj)
            Td      =   zeros(obj.nElem, obj.nDOFsElem);
            Tnod    =   obj.nodalConnectivity;
            
            for i=1:obj.nElem
                Td(i,1)=Tnod(i,1)*obj.nDim-2;
                Td(i,2)=Tnod(i,1)*obj.nDim-1;
                Td(i,3)=Tnod(i,1)*obj.nDim;
                Td(i,4)=Tnod(i,2)*obj.nDim-2;
                Td(i,5)=Tnod(i,2)*obj.nDim-1;
                Td(i,6)=Tnod(i,2)*obj.nDim;
            end
            obj.DOFsConnectivity =   Td;
        end
    end
end