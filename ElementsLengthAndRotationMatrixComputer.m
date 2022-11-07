classdef ElementsLengthAndRotationMatrixComputer < handle
    
    properties (Access = public)
        elemLength
        RotationMatrix
    end
    properties (Access = private)
        nodalConnectivity
        nodalCoordinates
        elemNumber
        P
    end

    methods (Access = public)
        function obj = ElementsLengthAndRotationMatrixComputer(cParams)
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
            obj.elemNumber=cParams.e;
        end

        function computePoints(obj)
            x=obj.nodalCoordinates;
            Tnod=obj.nodalConnectivity;
            e=obj.elemNumber;

            obj.P.x1e=x(Tnod(e,1),1);         
            obj.P.y1e=x(Tnod(e,1),2);             
            obj.P.z1e=x(Tnod(e,1),3);
            obj.P.x2e=x(Tnod(e,2),1);
            obj.P.y2e=x(Tnod(e,2),2);
            obj.P.z2e=x(Tnod(e,2),3);
        end

        function computeLengths(obj) 
            %x1=obj.P.x1e; obj.P.x potser és massa llarg, millor faig aixo?
            obj.elemLength=sqrt((obj.P.x2e-obj.P.x1e)^2+(obj.P.y2e-obj.P.y1e)^2+(obj.P.z2e-obj.P.z1e)^2);  
        end

        function computeRotationMatrix(obj)
            obj.RotationMatrix = 1/obj.elemLength*[obj.P.x2e-obj.P.x1e obj.P.y2e-obj.P.y1e obj.P.z2e-obj.P.z1e 0 0 0;
                           0 0 0 obj.P.x2e-obj.P.x1e obj.P.y2e-obj.P.y1e obj.P.z2e-obj.P.z1e];
        end
    end
end