classdef directSolver < Solver

    methods (Access = public)
        function obj=directSolver(cParams)
            obj.A=cParams.A;
            obj.b=cParams.b;
        end

        function x = resolution(obj)
            x=obj.A\obj.b;
        end
    end
end