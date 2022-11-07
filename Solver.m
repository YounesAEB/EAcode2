classdef Solver < handle

    %Solving Ax=b equations

    properties 
        freeDispl
    end

    properties (Access=private)
        A
        b
        solverType
        fixedDispl
        KLL
        KLR
        FL
    end

    methods (Access=public)
        function obj=Solver(cParams)
            obj.solverType=cParams.solverType;
            obj.A=cParams.A;
            obj.b=cParams.b;
        end

        function computeSolver(obj)
            obj.compute();
        end
    end

    methods (Access=private)
        function obj = compute(obj)
            switch obj.solverType 
                case "direct"
                obj.freeDispl = directSolver.resolution(obj.A,obj.b);
                case "iterative"
                obj.freeDispl = iterativeSolver.resolution(obj.A,obj.b);
            end
        end
    end
    
end

            


