function [x, y, logicalIndex, pointIndex] = nu_selectRectangle(varargin)

%% Select a part of plotted data
%
% This function returns
%
% "x" and "y" ...  
%       ... which are two double arrays containing a the data points within
%           the selected rectangle from a line or a scatter plot.
% "logicalIndex" ...
%       ... which is logical array, i.e., has the values 0 or 1, with the 
%           same length of the orignal data.
% "pointIndex" ...
%       ... which is a double array containing the indices of the selected 
%           points.
%
% Inputs
%
% "XDataSource" ...
%       ... whihc is either 'From Figure' (default), or the name of the
%           plotted x variable; 'From Figure' is suitable when there is only
%           one line or scatter plotted, the name of the x variable is needed
%           when there are more than one line or scatter ploted
%
% "YDataSource" ...
%       ... whihc is either 'From Figure' (default), or the name of the
%           plotted y variable; 'From Figure' is suitable when there is only
%           one line or scatter plotted, the name of the y variable is needed
%           when there are more than one line or scatter ploted
%
% "message" ...
%       ... which is the message to show in the pop up box before drawing 
%           the box; refered to as "Message" in the inputParser
%
% "plot_type" ...
%       ... can be either 'line' or 'scatter'; if nothing is written, 
%           the function will assume it is 'line'. refered to as "PlotType"
%           in the inputParser

%% Creating an inputParser object

p = inputParser;

defaultXDataSource = 'From Figure';
defaultYDataSource = 'From Figure';

defaultMessage = 'Click "OK" to select a rectangle for the data you want to extract!';

defaultPlotType = 'line';
validPlotTypes = {'line','scatter'};
checkPlotType = @(x) any(validatestring(x,validPlotTypes));

addParameter(p,'XDataSource',defaultXDataSource)
addParameter(p,'YDataSource',defaultYDataSource)
addParameter(p,'Message',defaultMessage)
addParameter(p,'PlotType',defaultPlotType,checkPlotType)


parse(p, varargin{:})

message = p.Results.Message;
plot_type = p.Results.PlotType;

%% Making sure the data is only saved when after checking the selection 

% Create an while to allow for repeating the selection

repeatSelection = 'Repeat';
while strcmp(repeatSelection, 'Repeat')
    
%% Extracting the x, y data from current plot

% The x and y data of the current figure is extracted and saved as "xData"
% and "yData"

    if strcmp(p.Results.XDataSource, 'From Figure')
        h = findobj(gca,'Type',plot_type);
    
        xData = h.XData';
        yData = h.YData';
    else
        xData = p.Results.XDataSource;
        yData = p.Results.YDataSource;
    end


%% Display the dialogue box 

% This is a dialogue box that gives you the chance to zoom in/out or pan 
% on the region from which you want to select the part of the plot.

    Ready= helpdlg(message);
    waitfor(Ready);

%% Extracting the data within the selected box

    k = waitforbuttonpress; 

    rect = getrect; % gets the lower left position and width and hight of the rectangle

    xv = [rect(1) rect(1)+rect(3) rect(1)+rect(3) rect(1) rect(1)]; % these are the x-coordinates of the five points defining the rectangle
    yv = [rect(2) rect(2) rect(2)+rect(4) rect(2)+rect(4) rect(2)]; % these are the y-coordinates of the five points defining the rectangle

    PointIndexLogical=inpolygon(xData, yData, xv, yv); % returns a 0 & 1 matrix with the points inside the rectangle

    logicalIndex = PointIndexLogical; % returns the 0 & 1 matrix as the output logicalIndex

    PointIndex = find(PointIndexLogical); % returns the index of the points inside the rectangle

    pointIndex = PointIndex; % returns the index matrix as the output pointIndex

    x = xData(PointIndex, 1); % returns the x-data inside the rectangle
    y = yData(PointIndex, 1); % return the y-data inside the rectangle

    
%% Check results
    hold on
    selected = plot(x, y, 'Color', [0.75 0.75 0.75], 'LineWidth'        ,   3);
    repeatSelection= questdlg('Do you want to ... this selection?','Save or Repeat','Save', 'Repeat', 'Save');
    waitfor(repeatSelection);
    delete(selected);

end
end