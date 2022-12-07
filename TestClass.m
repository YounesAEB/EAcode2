classdef TestClass < handle
    
    properties (Access = private)
        exactSolution
        calculatedSolution
    end

    methods (Access = public)
        function obj = TestClass(cParams)
            obj.init(cParams);
        end

        function check(obj)
            obj.checkGlobalStiffnessMatrix();
            obj.checkExteriorForces();
            obj.checkDispl();
            obj.checkStress();
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.exactSolution=cParams;
        end

        function checkGlobalStiffnessMatrix(obj)
            s.initialData        =   obj.exactSolution.initialData;
            s.dimensions         =   obj.exactSolution.dimensions;
            s.DOFsConnectivity   =   obj.exactSolution.DOFsConnectivity;
            k                    =   GlobalStiffnessMatrixComputer(s);
            k.compute();
            cParams.A = obj.exactSolution.globalK;
            cParams.B = k.globalK;
            c = SolutionComparator(cParams);
            c.check();
            d.comparatorBool = c.comparatorBool;
            d.testName = 'Global Stiffness Matrix';
            rd = TestDisplayer(d);
            rd.displayR();
        end

        function checkExteriorForces(obj)
            c.forcesData    =  obj.exactSolution.initialData.forcesData;
            c.numDOFsTotal   =  obj.exactSolution.dimensions.numDOFsTotal;
            c.numDimensions  =  obj.exactSolution.dimensions.numDimensions;
            f               =  GlobalForceVectorComputer(c);
            f.compute();
            cParams.A   =   obj.exactSolution.exteriorForces;
            cParams.B   =   f.Fext;
            c = SolutionComparator(cParams);
            c.check();
            d.comparatorBool = c.comparatorBool;
            d.testName = 'Exterior Forces';
            rd = TestDisplayer(d);
            rd.displayR();
        end

        function checkDispl(obj)
            c.solverType    =   obj.exactSolution.solverType;
            c.boundaryCond  =   obj.exactSolution.boundaryCond;
            c.globalK         =   obj.exactSolution.globalK;
            c.exteriorForces  =   obj.exactSolution.exteriorForces;
            d = DisplacementComputer(c);
            d.compute();
            cParams.A   =   d.displacements.displ;
            cParams.B   =   obj.exactSolution.displacements;
            c = SolutionComparator(cParams);
            c.check();
            p.comparatorBool = c.comparatorBool;
            p.testName = 'Displacements';
            rd = TestDisplayer(p);
            rd.displayR();  
        end

        function checkStress(obj)
            c.materialProperties    =  obj.exactSolution.initialData.materialProperties;
            c.materialConnectivity  =  obj.exactSolution.initialData.materialConnectivity;
            c.nodalCoordinates      =  obj.exactSolution.initialData.nodalCoordinates;
            c.nodalConnectivity     = obj.exactSolution.initialData.nodalConnectivity;
            c.dimensions        =   obj.exactSolution.dimensions;
            c.displ             =   obj.exactSolution.displacements;
            c.DOFsConnectivity  =   obj.exactSolution.DOFsConnectivity;
            ss                  =   StrainStressComputer(c);
            ss.compute();
            cParams.A          =   ss.stress;
            cParams.B          =   obj.exactSolution.stress;
            c = SolutionComparator(cParams);
            c.check();
            p.comparatorBool = c.comparatorBool;
            p.testName = 'Stress';
            rd = TestDisplayer(p);
            rd.displayR(); 
        end
    end
end