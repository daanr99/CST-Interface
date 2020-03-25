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

classdef TraceFromCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TraceFromCurve object.
        function obj = TraceFromCurve(project, hProject)
            obj.project = project;
            obj.hTraceFromCurve = hProject.invoke('TraceFromCurve');
        end
    end
    %% CST Object functions.
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With TraceFromCurve', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define tracefromcurve: ', obj.component, ':', obj.name, ''], obj.history);
            obj.history = [];
        end
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.component = '';
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Component(obj, component)
            obj.component = component;
            
            obj.AddToHistory(['.Component "', component, '"']);
        end
        function Material(obj, materialname)
            
            obj.AddToHistory(['.Material "', materialname, '"']);
        end
        function Curve(obj, curvename)
            
            obj.AddToHistory(['.Curve "', curvename, '"']);
        end
        function Thickness(obj, thickness)
            
            obj.AddToHistory(['.Thickness "', num2str(thickness), '"']);
        end
        function Width(obj, width)
            
            obj.AddToHistory(['.Width "', num2str(width), '"']);
        end
        function RoundStart(obj, boolean)
            
            obj.AddToHistory(['.RoundStart "', num2str(boolean), '"']);
        end
        function RoundEnd(obj, boolean)
            
            obj.AddToHistory(['.RoundEnd "', num2str(boolean), '"']);
        end
        function DeleteCurve(obj, boolean)
            
            obj.AddToHistory(['.DeleteCurve "', num2str(boolean), '"']);
        end
        function GapType(obj, gaptype)
            % Specifies the behavior of the creating solid on inflexion points of the curve.
            % type: 0 = rounded like arcs, 1 = extended like lines and 2 = natural like curve extensions
            
            obj.AddToHistory(['.GapType "', num2str(gaptype), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTraceFromCurve
        history
        
        name
        component
    end
end

% Default Settings
% Material ("Vacuum")
% Thickness (0.0)
% Width (0.0)
% RoundStart (False)
% RoundEnd (False)
% GapType(2)