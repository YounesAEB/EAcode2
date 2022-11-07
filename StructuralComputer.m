classdef StructuralComputer < handle

    properties (Access = public)
       displacements
       stress
       kGlob
       extForces
       data
       dimensions
       solverType
       DOFsConnectivity
    end
    properties (Access = private)
        strain
        reactions
        scale
        kElem
        freeDOFs
        fixedDOFs
        fixedDispl
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.init(cParams);
        end

        function globalComputer(obj)
            obj.assembleStiffnessMatrix();
            obj.assembleForceVector();
            obj.computeDisplReact();
            obj.computeStrainStress();
            %obj.plotDeformedStructure();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.data        =   Data(cParams);
            obj.data.setData();
            obj.dimensions  =   Dimensions.setDimensions(obj.data); %Cal evitar static methods? testalvia crear l'objecte i la classe es mes petita
            obj.solverType  =   cParams.type;
            obj.scale       =   cParams.scale;
        end

        function assembleStiffnessMatrix(obj)
            c.data               =   obj.data;
            c.dimensions         =   obj.dimensions;
            k                    =   GlobalStiffnessMatrixComputer(c);
            k.compute();
            obj.kElem            =   k.kElem;
            obj.kGlob            =   k.kGlob;
            obj.DOFsConnectivity =   k.DOFsConnectivity;
        end

        function assembleForceVector(obj)
            c.data          =  obj.data;
            c.dimensions    =  obj.dimensions;
            f               =  GlobalForceVectorAssembly(c);
            f.computeF();
            obj.extForces   =  f.Fext;
        end

        function computeDisplReact(obj)
            c.solverType    =   obj.solverType;
            c.data          =   obj.data;
            c.dimensions    =   obj.dimensions;
            c.kGlob         =   obj.kGlob;
            c.Fext          =   obj.extForces;
            d=DisplacementReactionObtention(c);
            d.compute();
            obj.displacements=d.displ;
            obj.reactions=d.react;
        end

        function computeStrainStress(obj)
            c.data              =   obj.data;
            c.dimensions        =   obj.dimensions;
            c.displ             =   obj.displacements;
            c.DOFsConnectivity  =   obj.DOFsConnectivity;
            ss                  =   StrainStressComputer(c);
            ss.compute();
            obj.stress          =   ss.sig;
            obj.strain          =   ss.eps;
        end

        function plotDeformedStructure(obj)
            cParams.dimensions  =   obj.dimensions;
            cParams.data        =   obj.data;
            cParams.stress      =   obj.stress;
            cParams.displ       =   obj.displacements;
            cParams.scale       =   obj.scale;
            p=PlotStress3D(cParams);
            p.plot();
        end
    end
end