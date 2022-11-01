classdef iterativeSolver < Solver

    methods (Access = public, Static)
       
        function uL = resolution(A,b)
            uL=pcg(A,b,1e-12,300);
        end
    end
end
