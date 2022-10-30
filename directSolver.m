classdef directSolver < Solver

    methods (Access = public)
        function obj=directSolver(cParams)
            obj.A=cParams.KLL;
            obj.b=cParams.FL-cParams.KLR*cParams.uR;
        end

        function x = resolution(obj)
            x=obj.A\obj.b;
        end
    end
end