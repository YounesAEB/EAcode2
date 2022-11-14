classdef ReactionsComputer < handle
    properties
        reactions
    end
    properties (Access=private)
        globalK
        exteriorForces
        splitGlobalK
        splitExtForces
        boundaryCond
    end

    methods (Access = public)
        function obj = ReactionsComputer (cParams)
            obj.init(cParams)
        end
        function compute(obj)
            obj.computeSplitK();
            obj.computeSplitF();
            obj.computeReactions();
        end
    end

    methods (Access = private)
        function  init(obj,cParams)
            obj.globalK      =   cParams.globalK;
            obj.exteriorForces = cParams.exteriorForces;
            obj.boundaryCond =   cParams.boundaryCond;
        end

        function computeSplitK (obj,cParams) %aquestes dues funcion són iguals a les de DisplacementComputer
                                             %l'alex només vol que surti de
                                             %DisplacementComputer els disp
            cParams.boundaryCond    = obj.boundaryCond;
            cParams.globalK         = obj.globalK;
            obj.splitGlobalK = DOFManager.splitStifnessMatrix(cParams);
        end

        function computeSplitF (obj,cParams)
            cParams.boundaryCond    = obj.boundaryCond;
            cParams.exteriorForces  = obj.exteriorForces;
            obj.splitExtForces = DOFManager.splitForceVector(cParams);
        end

        function computeReactions(obj)
            uR  =   obj.boundaryCond.fixedDispl;
            uL  =   obj.boundaryCond.freeDispl;
            KRL =   obj.splitGlobalK.KRL;
            KRR =   obj.splitGlobalK.KRR;
            FR  =   obj.splitExtForces.FR;
            obj.reactions = KRR*uR+KRL*uL-FR;
        end

    end
end