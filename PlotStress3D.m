classdef PlotStress3D < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access=private)
        nd
        X
        Y
        Z
        ux
        uy
        uz
        scale
        Tnod
        sig
    end

    methods
        function obj = PlotStress3D(cParams,dimensions,data,d,ss)
            % Precomputations
            obj.scale=cParams.scale;
            obj.nd = dimensions.numDimensions;
            obj.X = data.nodalCoordinates(:,1);
            obj.Y = data.nodalCoordinates(:,2);
            obj.Z = data.nodalCoordinates(:,3);
            obj.ux = d.displ(1:obj.nd:end);
            obj.uy = d.displ(2:obj.nd:end);
            obj.uz = d.displ(3:obj.nd:end);
            obj.Tnod= data.nodalConnectivities;
            obj.sig=ss.sig;
        end

        function plot(obj)
            figure
            hold on
            axis equal;
            colormap jet;
            
            % Plot undeformed structure
            plot3(obj.X(obj.Tnod)',obj.Y(obj.Tnod)',obj.Z(obj.Tnod)','-k','linewidth',0.5);
            
            % Plot deformed structure with stress colormapped
            patch(obj.X(obj.Tnod)'+obj.scale*obj.ux(obj.Tnod)',obj.Y(obj.Tnod)'+obj.scale*obj.uy(obj.Tnod)',obj.Z(obj.Tnod)'+obj.scale*obj.uz(obj.Tnod)',[obj.sig';obj.sig'],'edgecolor','flat','linewidth',2);
            
            % View angle
            view(45,20);
            
            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
            zlabel('z (m)')
            
            % Add title
            title(sprintf('Deformed structure (scale = %g)',obj.scale));
            
            % Add colorbar
            cbar = colorbar('Ticks',linspace(min(obj.sig),max(obj.sig),5));
            title(cbar,{'Stress';'(Pa)'});
        end
    end
end