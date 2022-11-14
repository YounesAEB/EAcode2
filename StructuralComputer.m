classdef StructuralComputer < handle

    properties (Access = public)
       displacements
       stress
       globalK
       exteriorForces
       initialData
       dimensions
       solverType
       DOFsConnectivity
       boundaryCond
    end
    properties (Access = private)
        strain
        reactions
        scale
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.init(cParams);
        end

        function globalComputer(obj)
            obj.computeStiffnessMatrix();
            obj.computeForceVector();
            obj.computeDisplacements();
            obj.computeReactions();
            obj.computeStrainStress();
            %obj.plotDeformedStructure();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.initialData =   Preprocess(cParams);
            obj.initialData.setInitialData();
            obj.dimensions  =   DimensionsComputer.computeDimensions(obj.initialData);
            obj.solverType  =   cParams.type;
            obj.scale       =   cParams.scale;
        end
            
        function computeStiffnessMatrix(obj)
            c.initialData        =   obj.initialData; % Es necessita tot
            c.dimensions         =   obj.dimensions;
            d                    =   DOFManager(c);
            d.compute();
            obj.boundaryCond     =   d.boundaryCond;
            obj.DOFsConnectivity =   d.DOFsConnectivity;
            c.DOFsConnectivity   =   obj.DOFsConnectivity;
            k                    =   GlobalStiffnessMatrixComputer(c);
            k.compute();
            obj.globalK          =   k.globalK;
        end

        function computeForceVector(obj)
            c.forcesData    =  obj.initialData.forcesData;
            c.numDOFsTotal  =  obj.dimensions.numDOFsTotal;
            c.numDimensions =  obj.dimensions.numDimensions;
            f               =  GlobalForceVectorAssembly(c);
            f.compute();
            obj.exteriorForces =  f.Fext;
        end

        function computeDisplacements(obj)
            c.solverType    =   obj.solverType;
            c.globalK       =   obj.globalK;
            c.exteriorForces =  obj.exteriorForces;
            c.boundaryCond  =   obj.boundaryCond;
            d               =   DisplacementComputer(c);
            d.compute();
            obj.boundaryCond.freeDispl = d.freeDispl;
            obj.displacements = d.displacements;
        end

        function computeReactions(obj)
            c.globalK       =   obj.globalK;
            c.exteriorForces =  obj.exteriorForces;
            c.boundaryCond  =   obj.boundaryCond;
            r               =   ReactionsComputer(c);
            r.compute();
            obj.reactions   =   r.reactions;
        end

        function computeStrainStress(obj)
            c.materialProperties   =   obj.initialData.materialProperties;
            c.materialConnectivity =   obj.initialData.materialConnectivity;
            c.nodalConnectivity    =   obj.initialData.nodalConnectivity;
            c.nodalCoordinates     =   obj.initialData.nodalCoordinates;
            c.dimensions        =   obj.dimensions;
            c.displ             =   obj.displacements;
            c.DOFsConnectivity  =   obj.DOFsConnectivity;
            ss                  =   StrainStressComputer(c);
            ss.compute();
            obj.stress          =   ss.stress;
            obj.strain          =   ss.strain;
        end

        function plotDeformedStructure(obj)
            cParams.dimensions  =   obj.dimensions;
            cParams.data        =   obj.initialData;
            cParams.stress      =   obj.stress;
            cParams.displ       =   obj.displacements;
            cParams.scale       =   obj.scale;
            p = PlotStress3D(cParams);
            p.plot();
        end
    end
end