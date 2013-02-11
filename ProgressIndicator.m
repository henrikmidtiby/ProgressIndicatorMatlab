classdef ProgressIndicator < handle
    %PROGRESSINDICATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        taskname
        startTime
        waitBarHandle
    end
    
    methods
        function obj = ProgressIndicator(taskname)
            if(nargin == 0)
                taskname = 'No taskname defined';
            end
            obj.taskname = taskname;
            obj.waitBarHandle = waitbar(0, 'Initializing waitbar...');
            obj.startTime = now;
        end
        function update(obj, itemsCompleted, totalItems)
            assert(itemsCompleted > 0);
            [message, fractionCompleted] = obj.generateMessage(itemsCompleted, totalItems);
            
            % Try to update the existing wait bar and if that fails 
            % create a new.
            try
                waitbar(fractionCompleted, obj.waitBarHandle, message);
            catch
                obj.waitBarHandle = waitbar(fractionCompleted, message);
            end
            
            % If all items have been processed, close the wait bar
            if(itemsCompleted == totalItems)
                obj.close();
            end
        end
        function [message, fractionCompleted] = generateMessage(obj, itemsCompleted, totalItems)
            fractionCompleted = itemsCompleted / totalItems;
            elapsedTime = now - obj.startTime;
            estimatedTimePerTask = elapsedTime / itemsCompleted;
            estimatedRemainingTime = estimatedTimePerTask * (totalItems - itemsCompleted);
            message = sprintf('%s: %d of %d completed.\nEstimated time of completion %s', obj.taskname, itemsCompleted, totalItems, datestr(now + estimatedRemainingTime));
        end
        function close(obj)
            try
                close(obj.waitBarHandle);
            catch
            end
        end
    end
    
end

