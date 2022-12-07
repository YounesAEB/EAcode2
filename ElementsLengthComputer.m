classdef ElementsLengthComputer < handle
    
    properties (Access = public)
        elemLength
    end
    properties (Access = private)
        nodalConnectivity
        nodalCoordinates
        iElem
        Point
    end

    methods (Access = public)
        function obj = ElementsLengthComputer(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computePoints();
            obj.computeLengths();
        end
    end

    methods (Access = private)
        function  init(obj,cParams)
            obj.nodalCoordinates=cParams.nodalCoordinates;
            obj.nodalConnectivity=cParams.nodalConnectivity;
            obj.iElem=cParams.iElem;
        end

        function computePoints(obj)
            x=obj.nodalCoordinates;
            Tnod=obj.nodalConnectivity;
            e=obj.iElem;

            obj.Point.x1e=x(Tnod(e,1),1);         
            obj.Point.y1e=x(Tnod(e,1),2);             
            obj.Point.z1e=x(Tnod(e,1),3);
            obj.Point.x2e=x(Tnod(e,2),1);
            obj.Point.y2e=x(Tnod(e,2),2);
            obj.Point.z2e=x(Tnod(e,2),3);
        end

        function computeLengths(obj) 
            %x1=obj.P.x1e; obj.P.x potser és massa llarg, millor faig aixo?
            obj.elemLength=sqrt((obj.Point.x2e-obj.Point.x1e)^2+(obj.Point.y2e-obj.Point.y1e)^2+(obj.Point.z2e-obj.Point.z1e)^2);  
        end
    end
end