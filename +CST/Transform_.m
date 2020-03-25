% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

% Still requires autogeneration.
     
classdef Transform_ < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Transform object.
        function obj = Transform_(project, hProject)
            obj.project = project;
            obj.hTransform = hProject.invoke('Transform');
            
            obj.Reset();
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function obj = Transform(obj, objecttype, transform)
            % objecttype: Curve, Shape, FFS, Port, CurrentDistribution,
            %             Part, LumpedElement
            % transform: Translate, Rotate, Scale, Mirror
            % Executes the given transform.
            % Should be called last.
            
            obj.AddToHistory(['.Transform "', objecttype, '", "', transform, '"']);
            
            % Prepend With and append End With
            obj.history = ['With Transform', newline, obj.history, 'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: ', transform, ' ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: ', transform, ' ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.names = {};
        end
        function Name(obj, name)
            % Removes all previous names specified using AddName
            obj.names = {name};
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function AddName(obj, name)
            % Allows transformation of multiple shapes.
            obj.names = [obj.names, {name}];
            
            obj.AddToHistory(['.AddName "', name, '"']);
        end
        function UsePickedPoints(obj, boolean)
            
            obj.AddToHistory(['.UsePickedPoints "', num2str(boolean), '"']);
        end
        function InvertPickedPoints(obj, boolean)
            
            obj.AddToHistory(['.InvertPickedPoints "', num2str(boolean), '"']);
        end
        function MultipleObjects(obj, boolean)
            % Copy shape, keeping original
            
            obj.AddToHistory(['.MultipleObjects "', num2str(boolean), '"']);
        end
        function GroupObjects(obj, boolean)
            
            obj.AddToHistory(['.GroupObjects "', num2str(boolean), '"']);
        end
        function Origin(obj, origin)
            % ShapeCenter, CommonCenter, Free
            
            obj.AddToHistory(['.Origin "', origin, '"']);
        end
        function Center(obj, xcenter, ycenter, zcenter)
            % Only works if Origin is set to 'Free'
            
            obj.AddToHistory(['.Center "', num2str(xcenter, '%.15g'), '", '...
                                      '"', num2str(ycenter, '%.15g'), '", '...
                                      '"', num2str(zcenter, '%.15g'), '"']);
        end
        function Vector(obj, xvector, yvector, zvector)
            
            obj.AddToHistory(['.Vector "', num2str(xvector, '%.15g'), '", '...
                                      '"', num2str(yvector, '%.15g'), '", '...
                                      '"', num2str(zvector, '%.15g'), '"']);
        end
        function ScaleFactor(obj, xscale, yscale, zscale)
            
            obj.AddToHistory(['.ScaleFactor "', num2str(xscale, '%.15g'), '", '...
                                           '"', num2str(yscale, '%.15g'), '", '...
                                           '"', num2str(zscale, '%.15g'), '"']);
        end
        function Angle(obj, xangle, yangle, zangle)
            
            obj.AddToHistory(['.Angle "', num2str(xangle, '%.15g'), '", '...
                                     '"', num2str(yangle, '%.15g'), '", '...
                                     '"', num2str(zangle, '%.15g'), '"']);
        end
        function PlaneNormal(obj, xplanenormal, yplanenormal, zplanenormal)
            
            obj.AddToHistory(['.PlaneNormal "', num2str(xplanenormal, '%.15g'), '", '...
                                           '"', num2str(yplanenormal, '%.15g'), '", '...
                                           '"', num2str(zplanenormal, '%.15g'), '"']);
        end
        function Repetitions(obj, repetitions)
            
            obj.AddToHistory(['.Repetitions "', num2str(repetitions), '"']);
        end
        function Component(obj, componentname)
            % Can be specified to move the translated object to another
            % component. Target component must already exist.
            
            obj.AddToHistory(['.Component "', componentname, '"']);
        end
        function Material(obj, materialname)
            % Sets the material of the new object.
            
            obj.AddToHistory(['.Material "', materialname, '"']);
        end
        function MultipleSelection(obj, boolean)
            
            obj.AddToHistory(['.MultipleSelection "', num2str(boolean), '"']);
        end
        
        function Destination(obj, destinationname)
            
            obj.AddToHistory(['.Destination "', destinationname, '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTransform
        history
        
        names
    end
end

%      .PlaneNormal "1", "0", "0" 
% Example translate
% With Transform 
%      .Reset 
%      .Name "cmp" 
%      .Vector "2*p", "0", "0" 
%      .UsePickedPoints "False" 
%      .InvertPickedPoints "False" 
%      .MultipleObjects "True" 
%      .GroupObjects "True" 
%      .Repetitions "1" 
%      .MultipleSelection "False" 
%      .Destination "" 
%      .Material "" 
%      .Transform "Shape", "Translate" 
% End With 



% Default settings.
% UsePickedPoints (False)
% InvertPickedPoints (False)
% MultipleObjects (False)
% GroupObjects (False)
% Origin ("ShapeCenter")