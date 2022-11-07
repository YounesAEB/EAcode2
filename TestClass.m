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
            obj.exactSolution=cParams.c;
        end

        function checkGlobalStiffnessMatrix(obj)
            s.data               =   obj.exactSolution.data;
            s.dimensions         =   obj.exactSolution.dimensions;
            k                    =   GlobalStiffnessMatrixComputer(s);
            k.compute();
            cParams.A = obj.exactSolution.kGlob;
            cParams.B = k.kGlob;
            c = SolutionComparator(cParams);
            c.check();
            d.comparatorBool=c.comparatorBool;
            d.testName= 'Global Stiffness Matrix';
            rd= TestDisplayer(d);
            rd.displayR();
        end

        function checkExteriorForces(obj)
            c.data          =  obj.exactSolution.data;
            c.dimensions    =  obj.exactSolution.dimensions;
            f               =  GlobalForceVectorAssembly(c);
            f.computeF();
            cParams.A= obj.exactSolution.extForces;
            cParams.B   =  f.Fext;
            c = SolutionComparator(cParams);
            c.check();
            d.comparatorBool=c.comparatorBool;
            d.testName= 'Exterior Forces';
            rd= TestDisplayer(d);
            rd.displayR();
        end

        function checkDispl(obj)
            c.solverType    =   obj.exactSolution.solverType;
            c.data          =   obj.exactSolution.data;
            c.dimensions    =   obj.exactSolution.dimensions;
            c.kGlob         =   obj.exactSolution.kGlob;
            c.Fext          =   obj.exactSolution.extForces;
            d=DisplacementReactionObtention(c);
            d.compute();
            cParams.A   =   d.displ;
            cParams.B   =   obj.exactSolution.displacements;
            c = SolutionComparator(cParams);
            c.check();
            p.comparatorBool=c.comparatorBool;
            p.testName= 'Displacements';
            rd= TestDisplayer(p);
            rd.displayR();  
        end

        function checkStress(obj)
            c.data              =   obj.exactSolution.data;
            c.dimensions        =   obj.exactSolution.dimensions;
            c.displ             =   obj.exactSolution.displacements;
            c.DOFsConnectivity  =   obj.exactSolution.DOFsConnectivity;
            ss                  =   StrainStressComputer(c);
            ss.compute();
            cParams.A          =   ss.sig;
            cParams.B          =   obj.exactSolution.stress;
            c = SolutionComparator(cParams);
            c.check();
            p.comparatorBool=c.comparatorBool;
            p.testName= 'Stress';
            rd= TestDisplayer(p);
            rd.displayR(); 
        end
    end
end