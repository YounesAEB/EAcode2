classdef directSolver < Solver

    methods (Access = public, Static)
       
        function uL = resolution(A,b)
            uL=A\b;
        end
    end
end