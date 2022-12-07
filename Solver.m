classdef Solver < handle
    
    properties (Access = protected)
        A
        b
    end
    
    %Solving Ax=b equations
    methods (Access=public, Static)
        function obj = create(cParams)
          switch cParams.solverType
              case 'direct'
                  obj = DirectSolver(cParams);
              case 'iterative'
                  obj = IterativeSolver(cParams);
          end
        end
    end
    
end

            


