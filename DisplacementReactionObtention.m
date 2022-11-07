classdef DisplacementReactionObtention < handle
    properties
        displ
        react
    end
    properties (Access=private)
        solverType
        dimensions
        fixNod
        kGlob
        KRR
        KRL
        KLR
        KLL
        Fext
        fixedDispl
        FR
        FL
        freeDOFs
        fixedDOFs
        freeDispl
    end

    methods (Access = public)
        function obj = DisplacementReactionObtention (cParams)
            obj.init(cParams)
        end
        function compute(obj)
            obj.applyCondFixed();
            obj.applyCondFree();
            obj.partitionKMatrix();
            obj.computeDisplacements();
            obj.computeReactions();
        end
    end

    methods (Access = private)
        function  init(obj,cParams)
            obj.fixNod=cParams.data.fixNod;
            obj.dimensions=cParams.dimensions;
            obj.kGlob=cParams.kGlob;
            obj.Fext=cParams.Fext;
            obj.solverType=cParams.solverType;
        end
        
        function obj = applyCondFixed(obj)
            vR=zeros(size(obj.fixNod,1),1);
            uR=ones(size(obj.fixNod,1),1);
            
            for i=1:size(obj.fixNod,1)    
                if obj.fixNod(i,2)==1
                   vR(i)=3*obj.fixNod(i,1)-2;
                   uR(i)=obj.fixNod(i,3);
                else
                    if obj.fixNod(i,2)==2
                       vR(i)=3*obj.fixNod(i,1)-1;
                       uR(i)=obj.fixNod(i,3);
                    else
                        if obj.fixNod(i,2)==3
                           vR(i)=3*obj.fixNod(i,1);
                           uR(i)=obj.fixNod(i,3);
                        end
                    end
                end
            end
        
            obj.fixedDOFs=vR;
            obj.fixedDispl=uR;
        end

        function applyCondFree(obj)
            n_dof=obj.dimensions.numDOFsTotal;
            v=linspace(1,n_dof,n_dof);
            vL=setdiff(v,obj.fixedDOFs);
            obj.freeDOFs=vL;
        end

        function obj =partitionKMatrix (obj)
            vL=obj.freeDOFs;
            vR=obj.fixedDOFs;
            KG=obj.kGlob;

            obj.KRR = KG(vR, vR);
            obj.KRL = KG(vR, vL);
            obj.KLR = KG(vL, vR);
            obj.KLL = KG(vL, vL);
            obj.FL = obj.Fext(vL, 1);
            obj.FR = obj.Fext(vR, 1);
        end

        function computeDisplacements(obj) 
            cParams.solverType=obj.solverType;
            cParams.A=obj.KLL;
            cParams.b=obj.FL-obj.KLR*obj.fixedDispl;
            s=Solver.create(cParams);
            obj.freeDispl=s.solve();

            vL=obj.freeDOFs;
            vR=obj.fixedDOFs;         
            obj.displ(vL,1)=obj.freeDispl;
            obj.displ(vR,1)=obj.fixedDispl;
        end

        function computeReactions(obj)
            uR=obj.fixedDispl;
            uL=obj.freeDispl;
            R = obj.KRR*uR+obj.KRL*uL-obj.FR;
            obj.react=R;
        end

    end
end