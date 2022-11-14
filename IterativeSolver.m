classdef IterativeSolver < Solver
    
    properties (Access = private)
        A
        b
    end

    methods (Access = public)
        function obj=IterativeSolver(cParams)
            obj.A=cParams.A;
            obj.b=cParams.b;
        end
       
        function uL = solve(obj)
            uL=pcg(obj.A,obj.b,1e-12,300);
        end
    end
end