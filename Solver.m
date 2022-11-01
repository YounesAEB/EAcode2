classdef Solver < handle

    %Solving Ax=b equations

    properties 
        A
        b
        freeDOFs
        fixedDOFs
        fixedDispl
        freeDispl
        KRR
        KRL
        KLL
        KLR
        FL
        FR
    end

    properties (Access=private)
        fixNod
        Fext
        solverType
        kGlob
        dimensions
    end

    methods (Access=public)
        function obj=Solver(cParams)
            obj.solverType=cParams.solverType;
            obj.fixNod=cParams.data.fixNod;
            obj.dimensions=cParams.dimensions;
            obj.kGlob=cParams.kGlob;
            obj.Fext=cParams.Fext;
        end

        function computeSolver(obj)
            obj.applyCond();
            obj.partitionK();
            obj.equationObtention();
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

        function obj = applyCond(obj) %[vL,vR,uR] =
            n_dof=obj.dimensions.numDOFsTotal;

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
            
            vL=zeros(n_dof-size(obj.fixNod,1),1);
            suma=1;
            for i=1:n_dof
                cont=0;
                for j=1:size(vR)
                    if i==vR(j)
                       cont=cont+1;
                    end
                end
                if cont==0 
                   vL(suma)=i;
                   suma=suma+1;
                end
            end

            obj.freeDOFs=vL;
            obj.fixedDOFs=vR;
            obj.fixedDispl=uR;
        end

        function obj =partitionK (obj)
            vL=obj.freeDOFs;
            vR=obj.fixedDOFs;
            KG=obj.kGlob;
            %Matriu KRR
            obj.KRR = zeros(numel(vR),numel(vR));
            for i = 1:numel(vR)
                for j = 1:numel(vR)
                    obj.KRR(i,j)=KG(vR(i),vR(j));  
                end
            end   
            %Matriu KRL
            obj.KRL = zeros(numel(vR),numel(vL));
            for i = 1:numel(vR)
                for j = 1:numel(vL)
                    obj.KRL(i,j)=KG(vR(i),vL(j));  
                end
            end
                
            %Matriu KLR
            obj.KLR = zeros(numel(vL),numel(vR));
            for i = 1:numel(vL)
                for j = 1:numel(vR)
                    obj.KLR(i,j)=KG(vL(i),vR(j));   
                end
            end
            
            %Matriu KLL
            obj.KLL = zeros(numel(vL),numel(vL));
            for i = 1:numel(vL)
                for j = 1:numel(vL)
                    obj.KLL(i,j)=KG(vL(i),vL(j));
                end
            end
                
            %Vector FL
            obj.FL = zeros(numel(vL),1);
            for i = 1:numel(vL)
               obj.FL(i,1)=obj.Fext(vL(i),1);
            end 
            
            %Vector FR
            obj.FR = zeros(numel(vR),1);
            for i = 1:numel(vR)
               obj.FR(i,1)=obj.Fext(vR(i),1);
            end 
        end

        function obj=equationObtention(obj)
            obj.A=obj.KLL;
            obj.b=obj.FL-obj.KLR*obj.fixedDispl;
        end

    end
end

            


