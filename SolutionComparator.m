classdef SolutionComparator < handle
    properties
        A
        B
        comparatorBool %better name?
    end
    properties (Constant)
        delta = 1e-12;
    end

    methods
        function obj = SolutionComparator(cParams)
            obj.init(cParams);
        end

        function check(obj)
            obj.compare();
        end
    end
    methods (Access = private)
        function  init(obj,cParams)
            obj.A=cParams.A;  
            obj.B=cParams.B;
        end

        function compare(obj)
            %obj.comparatorBool = islogical(max(abs(obj.A-obj.B))<obj.delta);
            if max(abs(obj.A-obj.B))<obj.delta
                obj.comparatorBool = true;
            else
                obj.comparatorBool = false;
            end
        end
    end
end