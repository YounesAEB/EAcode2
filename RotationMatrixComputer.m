classdef RotationMatrixComputer < handle
    
    properties (Access = public)
        rotationMatrix
    end
    properties (Access = private)
        elemLength
        nodalConnectivity
        nodalCoordinates
        iElem
        Point
    end

    methods (Access = public)
        function obj = RotationMatrixComputer(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computePoints();
            obj.computeLengths();
            obj.computeRotationMatrix();
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

        function computeRotationMatrix(obj)
            obj.rotationMatrix = 1/obj.elemLength*[obj.Point.x2e-obj.Point.x1e obj.Point.y2e-obj.Point.y1e obj.Point.z2e-obj.Point.z1e 0 0 0;
                           0 0 0 obj.Point.x2e-obj.Point.x1e obj.Point.y2e-obj.Point.y1e obj.Point.z2e-obj.Point.z1e];
        end
    end
end