classdef Dimensions < handle
    
    properties
        numDimensions %= number of DOFs per each node
        numDOFsNode % Number of nodes per each node
        numNodesTotal 
        numDOFsTotal
        numElements
        numNodesElement
        numDOFsElement
    end
    
    methods (Access=public, Static)
        function obj = setDimensions(data)
            x=data.nodalCoordinates;
            Tnod=data.nodalConnectivities;
            
            obj.numDimensions=size(x,2);
            obj.numDOFsNode=obj.numDimensions;
            obj.numNodesTotal=size(x,1);
            obj.numDOFsTotal=obj.numDOFsNode*obj.numNodesTotal;
            obj.numElements=size(Tnod,1);
            obj.numNodesElement=size(Tnod,2);
            obj.numDOFsElement=obj.numDimensions*obj.numNodesElement;
        end

    end
end
