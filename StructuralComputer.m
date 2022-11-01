classdef StructuralComputer < handle

    properties (Access=public)
       displ
       reactions
       stress
       strain
    end
    properties (Access=private)
        solverType
        data
        dimensions
        kElem
        kGlob
        elemLong
        DOFsConnectivity
        extForces
        freeDOFs
        fixedDOFs
        freeDispl
        fixedDispl
    end

    methods (Access=public)
        function obj = StructuralComputer(cParams)
            obj.init(cParams)
        end

        function globalComputer(obj)
            obj.assembleStiffnessMatrix();
            obj.assembleForceVector();
            obj.computeDisplReact();
            obj.computeStrainStress();
        end
    end

    methods (Access=private)
        function init(obj,cParams)
            obj.data        =   Data.setData(cParams);
            obj.dimensions  =   Dimensions.setDimensions(obj.data);
            obj.solverType  =   cParams.type;
        end

        function assembleStiffnessMatrix(obj)
            c.data               =   obj.data;
            c.dimensions         =   obj.dimensions;
            k                    =   GlobalStiffnessMatrixComputer(c);
            k.compute();
            obj.kElem            =   k.kElem;
            obj.kGlob            =   k.kGlob;
            obj.elemLong         =   k.elementsLong;
            obj.DOFsConnectivity =   k.DOFsConnectivity;
        end

        function assembleForceVector(obj)
            c.data          =  obj.data;
            c.dimensions    =  obj.dimensions;
            f               =  GlobalForceVectorAssembly(c);
            f.computeF();
            obj.extForces   =  f.Fext;
        end

        function computeDisplReact(obj) %Solver class is too big, must be shorted. lo d las particiones y la resolucion es lo que se deberia pasar
            c.solverType    =   obj.solverType;
            c.data          =   obj.data;
            c.dimensions    =   obj.dimensions;
            c.kGlob         =   obj.kGlob;
            c.Fext          =   obj.extForces;
            s               =   Solver(c);
            s.computeSolver();
            a.KRR=s.KRR;
            a.KRL=s.KRL;
            a.fixedDispl=s.fixedDispl;
            a.freeDispl=s.freeDispl;
            a.freeDOFs=s.freeDOFs;
            a.fixedDOFs=s.fixedDOFs;
            a.FR=s.FR;
            d=DisplacementReactionObtention(a);
            d.compute();
            obj.displ=d.displ;
            obj.reactions=d.react;
        end

        function computeStrainStress(obj)
            c.data=obj.data;
            c.dimensions=obj.dimensions;
            c.displ=obj.displ;
            c.elemLong=obj.elemLong;
            c.DOFsConnectivity=obj.DOFsConnectivity;
            ss=StrainStressComputer(c);
            ss.compute();
            obj.stress=ss.sig;
            obj.strain=ss.eps;
        end
    end
end