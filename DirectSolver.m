classdef DirectSolver < Solver

    methods (Access = public)
        function obj=DirectSolver(cParams)
            obj.A = cParams.A;
            obj.b = cParams.b;
        end
       
        function uL = solve(obj)
            uL = obj.A\obj.b;
        end
    end
end