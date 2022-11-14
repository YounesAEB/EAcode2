classdef DOFManager < handle

    properties (Access = public)
        DOFsConnectivity
        boundaryCond
    end
    properties (Access = private)
        dimensions
        initialData
        fixNod
    end

    methods (Access = public)
        function obj = DOFManager(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.DOFsConnectivityComputer();
            obj.applyCondFixed();
            obj.applyCondFree();
        end
    end

    methods (Access = public, Static)
        function splitK = splitStifnessMatrix(cParams)
            vL  =   cParams.boundaryCond.freeDOFs;
            vR  =   cParams.boundaryCond.fixedDOFs;
            KG  =   cParams.globalK;

            splitK.KRR = KG(vR, vR);
            splitK.KRL = KG(vR, vL);
            splitK.KLR = KG(vL, vR);
            splitK.KLL = KG(vL, vL);
        end

        function splitF = splitForceVector(cParams)
            vL      =   cParams.boundaryCond.freeDOFs;
            vR      =   cParams.boundaryCond.fixedDOFs;
            Fext    =   cParams.exteriorForces;
            
            splitF.FL = Fext(vL, 1);
            splitF.FR = Fext(vR, 1);
        end

     end

    methods (Access = private)
        function init(obj,cParams)
            obj.initialData     =   cParams.initialData;
            obj.dimensions      =   cParams.dimensions;
            obj.fixNod          =   cParams.initialData.fixNod;
        end
        
        function DOFsConnectivityComputer(obj)
            Td      =   zeros(obj.dimensions.numElements, obj.dimensions.numDOFsElement);
            Tnod    =   obj.initialData.nodalConnectivity;
            nd      =   obj.dimensions.numDimensions;

            for i=1:obj.dimensions.numElements
                Td(i,1)=Tnod(i,1)*nd-2;
                Td(i,2)=Tnod(i,1)*nd-1;
                Td(i,3)=Tnod(i,1)*nd;
                Td(i,4)=Tnod(i,2)*nd-2;
                Td(i,5)=Tnod(i,2)*nd-1;
                Td(i,6)=Tnod(i,2)*nd;
            end
            obj.DOFsConnectivity    =   Td;
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
        
            obj.boundaryCond.fixedDOFs=vR;
            obj.boundaryCond.fixedDispl=uR;
        end

        function applyCondFree(obj)
            n_dof=obj.dimensions.numDOFsTotal;
            v=linspace(1,n_dof,n_dof);
            vL=setdiff(v,obj.boundaryCond.fixedDOFs);
            obj.boundaryCond.freeDOFs=vL;
        end
    end
end