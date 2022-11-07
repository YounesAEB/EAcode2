classdef PlotStress3D < handle

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
        function obj = PlotStress3D(cParams)
            % Precomputations
            obj.scale   = cParams.scale;
            obj.nd      = cParams.dimensions.numDimensions;
            obj.X       = cParams.data.nodalCoordinates(:,1);
            obj.Y       = cParams.data.nodalCoordinates(:,2);
            obj.Z       = cParams.data.nodalCoordinates(:,3);
            obj.ux      = cParams.displ(1:obj.nd:end);
            obj.uy      = cParams.displ(2:obj.nd:end);
            obj.uz      = cParams.displ(3:obj.nd:end);
            obj.Tnod    = cParams.data.nodalConnectivity;
            obj.sig     = cParams.stress;
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