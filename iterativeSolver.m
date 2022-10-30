classdef iterativeSolver < Solver

    methods (Access = public)
        function obj=iterativeSolver(cParams)
            obj.A=cParams.KLL;
            obj.b=cParams.FL-cParams.KLR*cParams.uR;
        end

        function x = resolution(obj)
            x=pcg(obj.A,obj.b,1e-12,300);
        end
    end
end