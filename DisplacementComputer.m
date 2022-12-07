classdef DisplacementComputer < handle
    properties (Access = public)
        displacements
        freeDispl
    end
    properties (Access=private)
        solverType
        exteriorForces
        globalK
        splitGlobalK
        splitExtForces
        boundaryCond
    end

    methods (Access = public)
        function obj = DisplacementComputer (cParams)
            obj.init(cParams)
        end
        function compute(obj)
            obj.computeSplitK();
            obj.computeSplitF();
            obj.computeDisplacements();
        end
    end

    methods (Access = private)
        function  init(obj,cParams)
            obj.globalK      =   cParams.globalK;
            obj.exteriorForces = cParams.exteriorForces;
            obj.solverType   =   cParams.solverType;
            obj.boundaryCond =   cParams.boundaryCond;
        end

        function computeSplitK (obj,cParams)
            cParams.boundaryCond    = obj.boundaryCond;
            cParams.globalK         = obj.globalK;
            obj.splitGlobalK = DOFManager.splitStifnessMatrix(cParams);
        end

        function computeSplitF (obj,cParams)
            cParams.boundaryCond    = obj.boundaryCond;
            cParams.exteriorForces  = obj.exteriorForces;
            obj.splitExtForces = DOFManager.splitForceVector(cParams);
        end

        function computeDisplacements(obj) 
            KLL                 =   obj.splitGlobalK.KLL;
            FL                  =   obj.splitExtForces.FL;
            uR                  =   obj.boundaryCond.fixedDispl;
            KLR                 =   obj.splitGlobalK.KLR;
            cParams.A           =   KLL;
            cParams.b           =   FL-KLR*uR;
            cParams.solverType  =   obj.solverType;
            s = Solver.create(cParams);
            obj.freeDispl       =   s.solve();

            c.boundaryCond = obj.boundaryCond;       
            c.freeDispl = obj.freeDispl;
            obj.displacements = DOFManager.joinDisplacementVector(c);
        end

    end
end