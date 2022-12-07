classdef StructuralComputer < handle

    properties (Access = public)
        stress
    end
    properties (Access = private)
        displacements
        globalK
        exteriorForces
        initialData
        dimensions
        solverType
        DOFsConnectivity
        boundaryCond
        strain
        reactions
        scale
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.init(cParams);
        end

        function globalComputer(obj)
            obj.computeDOFsConnectivity();
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

        function computeDOFsConnectivity(obj)
            c.nDim = obj.dimensions.numDimensions;
            c.nElem = obj.dimensions.numElements;
            c.nDOFsElem = obj.dimensions.numDOFsElement;
            c.nodalConnectivity = obj.initialData.nodalConnectivity;
            s = DOFsConnectivityComputer(c);
            obj.DOFsConnectivity = s.DOFsConnectivity;
        end
            
        function computeStiffnessMatrix(obj)
            c.initialData        =   obj.initialData; % Es necessita tot
            c.dimensions         =   obj.dimensions;
            d                    =   DOFManager(c);
            d.compute();
            obj.boundaryCond     =   d.boundaryCond;
            c.DOFsConnectivity   =   obj.DOFsConnectivity;
            k                    =   GlobalStiffnessMatrixComputer(c);
            k.compute();
            obj.globalK          =   k.globalK;
        end

        function computeForceVector(obj)
            c.forcesData    =  obj.initialData.forcesData;
            c.numDOFsTotal  =  obj.dimensions.numDOFsTotal;
            c.numDimensions =  obj.dimensions.numDimensions;
            f               =  GlobalForceVectorComputer(c);
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
            obj.displacements = d.displacements.displ;
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
            c.dimensions  =   obj.dimensions;
            c.data        =   obj.initialData;
            c.stress      =   obj.stress;
            c.displ       =   obj.displacements;
            c.scale       =   obj.scale;
            p = PlotStress3D(c);
            p.plot();
        end
    end
end