classdef DisplacementReactionObtention
    properties
        displ
        react
    end
    properties (Access=private)
        KRR
        KRL
        uR
        uL
        FR
        vL
        vR
    end

    methods (Access=public)
        function obj = DisplacementReactionObtention(s)
            obj.KRR=s.KRR;
            obj.KRL=s.KRL;
            obj.uR=s.fixedDispl;
            obj.uL=s.freeDispl;
            obj.vL=s.freeDOFs;
            obj.vR=s.fixedDOFs;
            obj.FR=s.FR;
        end

        function obj=compute(obj)
            R = obj.KRR*obj.uR+obj.KRL*obj.uL-obj.FR;
            obj.react=R;

            %Obtenció del vector u amb tots els desplaçaments
            u = zeros(numel(obj.vL)+numel(obj.vR),1);
            for i = 1:numel(obj.vR)
                u(obj.vR(i),1) = obj.uR(i,1);
            end
            for i = 1:numel(obj.vL)
                u(obj.vL(i),1) = obj.uL(i,1) ;
            end
            obj.displ=u;
        end
    end
end