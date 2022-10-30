classdef GlobalForceVectorAssembly

    methods
        function obj = GlobalForceVectorAssembly()
        end

        function Fext = computeF(obj,n_i,n_dof,Fdata)
            Fext=zeros(n_dof,1);
            for k=1:size(Fdata,1)
                if Fdata(k,2)==1
                Fext(Fdata(k,1)*n_i-1)=Fdata(k,3);
                else 
                Fext(Fdata(k,1)*n_i)=Fdata(k,3);
                end
            end
        end
    end
end