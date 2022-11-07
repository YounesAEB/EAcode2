classdef TestDisplayer < handle

    properties
        testName
        comparatorBool
    end

    methods
        function obj = TestDisplayer(cParams)
            obj.init(cParams)
        end
        function displayR(obj)
            obj.displayResults();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.testName=cParams.testName;
            obj.comparatorBool=cParams.comparatorBool;
        end
        function displayResults(obj)
            if (obj.comparatorBool==1)
                disp([obj.testName,': Test passed :).'])
            else
                disp([obj.testName,': Test not passed :(.'])
            end
        end
    end
end