classdef Solver < handle
    
    properties
        A;
        b;
    end

    methods (Access=public, Static)
        function obj = create(cParams) %esto NO se puede hacer como un constructor normal, sino como una función.
          switch cParams.type
              case 'direct'
                  obj = directSolver(cParams);
              case 'iterative'
                  obj = iterativeSolver(cParams);
          end
        end
    end

end