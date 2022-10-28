classdef iterativeSolver < Solver

    methods (Access = public)
        function obj=iterativeSolver(cParams)
            obj.A=cParams.A;
            obj.b=cParams.b;
        end

        function x = resolution(obj)
            x=pcg(obj.A,obj.b);
        end
    end
end