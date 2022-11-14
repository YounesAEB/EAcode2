classdef GlobalForceVectorAssembly < handle

    properties (Access=public)
        Fext
    end

    properties (Access=private)
        forcesData
        numDOFsTotal
        numDimensions
    end

    methods (Access=public)
        function obj = GlobalForceVectorAssembly(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computeFext;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.forcesData=cParams.forcesData;
            obj.numDOFsTotal=cParams.numDOFsTotal;
            obj.numDimensions=cParams.numDimensions;
        end

        function obj=computeFext(obj)
            obj.Fext=zeros(obj.numDOFsTotal,1);
            for k=1:size(obj.forcesData,1)
                if obj.forcesData(k,2)==1
                obj.Fext(obj.forcesData(k,1)*obj.numDimensions-1)=obj.forcesData(k,3);
                else 
                obj.Fext(obj.forcesData(k,1)*obj.numDimensions)=obj.forcesData(k,3);
                end
            end
        end
    end
end