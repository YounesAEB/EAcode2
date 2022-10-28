classdef GlobalStiffnessMatrixComputer

    properties
        Kelem
        Tnod
        numNodesTotal
        numDOFsTotal
        numElements
        numNodesElement
        numDimensions %=number of DOFs per each node
        numDOFsElement
    end

    methods
        %Primer el constructor, tot i que no faci res, cal que
        %s'inicialitzi
        function obj = GlobalStiffnessMatrixComputer(Kelem,Tnod,n,n_dof)
            obj.Kelem=Kelem;
            obj.Tnod=Tnod;
            obj.numNodesTotal=n;
            obj.numDOFsTotal=n_dof;
            obj.numElements=size(Tnod,1);
            obj.numNodesElement=size(Tnod,2);
            obj.numDimensions=n_dof/n;
            obj.numDOFsElement=n_dof/n*size(Tnod,2);
        end
        
        function Td=connectDOFS(obj)
            Td = zeros(obj.numElements, obj.numDOFsElement);
            for i=1:obj.numElements
                Td(i,1)=obj.Tnod(i,1)*obj.numDimensions-2;
                Td(i,2)=obj.Tnod(i,1)*obj.numDimensions-1;
                Td(i,3)=obj.Tnod(i,1)*obj.numDimensions;
                Td(i,4)=obj.Tnod(i,2)*obj.numDimensions-2;
                Td(i,5)=obj.Tnod(i,2)*obj.numDimensions-1;
                Td(i,6)=obj.Tnod(i,2)*obj.numDimensions;
            end
        end

        function KG = assemblyKG(obj,Td)
            KG=zeros(obj.numDOFsTotal);
            for e=1:obj.numElements
                for i=1:obj.numDOFsElement
                    I=Td(e,i);
                    for j=1:obj.numDOFsElement
                        J=Td(e,j);
                        KG(I,J)=KG(I,J)+obj.Kelem(i,j,e);
                    end
                end
    
            end
        end

    end
end