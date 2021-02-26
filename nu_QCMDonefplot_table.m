function [FreqAxis , LineHandle    ,   BaselineIndex   ,   StartEndTimes]   =   ...
                    nu_QCMDonefplot_table(   TableName   ,   Overtone    ,   varargin)
% 
% This function creates a plot for one overtone from a QCM-D experiment and
% returns
%
% "LineHande" ...
%       ... which is line handle to refer to the ploted line
%
% "BaselineIndex" ...
%       ... which is the index for the baseline (freq = 0) for the plot
%
% "StartEndTimes" ...
%       ... which is the start and end times of the plot
%
% Inputs
%
% "TableName" ...
%       ... whihc is the table containing the QCM-D data
%
% "Overtone" ...
%       ... whihc is the overtone number to plot
%
% "FreqAxis" ...
%       ... which is an option to choose an already existing axis to plot  
%       the data to; otherwise the function creates new fig and axis. 
%       Default value is empty.
%
% "RefIndex" ...
%         ... which is vector array containing the indices of the baseline:
%               - [] will triger interactive selection of the baseline
%               - [0] no baseline, will plot the data as it is
%               - [1] is the default, uses the first point as a baseline
%
% "Normalize" ...
%       ... which is an option to decide whether to plot the freq. or the
%       freq./n; n is the number of overtones. this could be
%               - 'yes'
%               - 'no'
%       'yes' is defualt
%
% "TimeLimits" ...
%       ... which is a two element array of containing the starting and end
%       times of the plot; the parameter could have the following values
%               - [] will triger interactive selection of start and end 
%               time points 
%               - [0] is the default, will plot the whole time range 
%               - [StartTime EndTime] will plot between the start and end
%               time points
%
% "TimeZero' ...
%       ... which is a scalar input for the time to be used as time zero
%           - 0 is default
%           - NewZero is a new given value
%           - [] will triger interactive selection of time zero
% 
% "ColorMarkerNumber" ...
%       ... which is an integer between 1 and 7 refering to different
%       shades of blue and markers. Default is [] , which returns the same 
%       as the overtoneindex.
%
% "Output" ...
%       ... which is a string to determine the type of trageted output:
%               - 'Screen', default
%               - 'Paper'

%% Creating an inputParser object
p   =   inputParser;

defaultNormalize            =   'yes';
validNormalize              =   {   'yes'    ,   'no'   };
checkNormalize              =   @(x) any(validatestring(x ,   validNormalize));

defaultRefIndex             =   1;

defaultFreqAxis             =   [];

defaultTimeLimits           =   0;

defaultColorMarkerNumber    =   [];

defaultOutput       =   'Screen';

addRequired(    p   ,   'ExpNo')
addRequired(    p   ,   'Overtone')

addParameter(   p   ,   'Normalize'         ,   defaultNormalize    ,   checkNormalize  )
addParameter(   p   ,   'RefIndex'          ,   defaultRefIndex                         )
addParameter(   p   ,   'FreqAxis'          ,   defaultFreqAxis                         )
addParameter(   p   ,   'TimeLimits'        ,   defaultTimeLimits                       )
addParameter(   p   ,   'ColorMarkerNumber' ,   defaultColorMarkerNumber                )
addParameter(   p   ,   'Output'            ,   defaultOutput                           )

parse(p ,   TableName   ,   Overtone    ,   varargin{:})


Normalize           =   p.Results.Normalize;
RefIndex            =   p.Results.RefIndex;
FreqAxis            =   p.Results.FreqAxis;
TimeLimits          =   p.Results.TimeLimits;
ColorMarkerNumber   =   p.Results.ColorMarkerNumber;
Output              =   p.Results.Output;


%% extracting the data to be plotted
% calculating the overtone index
OvertoneIndex   =   (Overtone    +   1);

% extracting the time data and storing it in a variable "Time"
Time            =   TableName{  :   ,   1 };

% extracting the freq data and storing it in a variable f
if      strcmp(  Normalize  , 'yes')
    
    f               =   TableName{ :   ,   OvertoneIndex   };
    axis_label      =   '$\Delta f_{n}/n \; [\mathrm{Hz}]$';
    legend_label    =   ['$\Delta f_{', num2str( Overtone ), '}/', num2str( Overtone ) , '$'];
    
elseif  strcmp(  Normalize  , 'no')
    
    f               =   TableName.dfn_n{ :   ,   OvertoneIndex   }  *   Overtone;
    axis_label      =   '$\Delta f_{n} \; [\mathrm{Hz}]$';
    legend_label    =   ['$\Delta f_{', num2str( Overtone ), '$'];
end

%% extracting the data based on the start and end times of the plot
if isempty(TimeLimits)
    temp_fig            =   figure;
    temp_fig.Units      =   'normalized';
    temp_fig.Position   =   [0 0 1 1];
        
    % plotting the data
    plot(   Time    ,   f   );
    
    Ready   =   helpdlg(    'Select the start time of the plot'     ,   'Start Time'    );
    waitfor( Ready );
        
    [   TimeLimits(1)   ,    ~   ]    =   ginput;
    
    Ready   =   helpdlg(    'Select the end time of the plot'     ,   'Start Time'    );
    waitfor( Ready );
        
    [   TimeLimits(2)   ,    ~   ]    =   ginput;
    
    prompt          =   {   'Start Time'   ,   'End Time'   };
    dlg_title       =   'Time Limits';
    default_ans     =   {   num2str(    TimeLimits( 1 ) )   ,   num2str(    TimeLimits( 2 ) ) };
    num_lines       =   1;
    TimeLimits      =   newid   (  prompt  ,   dlg_title   ,   num_lines   ,   default_ans );
    TimeLimits      =   str2double( TimeLimits )';
    
    close(temp_fig);
end
if TimeLimits ~= 0
    index(1)    =   find(   Time(:,1) < TimeLimits(1)   ,   1   ,   'last'  );
    index(2)    =   find(   Time(:,1) > TimeLimits(2)   ,   1   ,   'first' );
    Time    =   Time(   index(1):index(2)   );
    f       =   f(  index(1):index(2)   );
end

StartEndTimes    =   TimeLimits;

%% determining the zero frequency value
BaselineIndex   =   0; % starting value, will be used if RefIndex = 0

if  isempty(RefIndex)
    
    % create a temporary figure to select the zero value
    temp_fig            =   figure;
    temp_fig.Units      =   'normalized';
    temp_fig.Position   =   [0 0 1 1];
        
    % plotting the data
    plot(   Time    ,   f   );
        
    % select the data points for the zero value
    [   ~   ,   ~   ,   ~   ,   RefIndex]  ...
                        =   nu_selectRectangle ...
                            (   'Message'   ,   'Select the data points to be use a baseline (freq = 0)', ...
                                'PlotType'  ,   'line');
    close(temp_fig);
    
end

if RefIndex ~= 0
    % calculating the new frequency shift
    BaselineIndex           =   RefIndex;
    f_zero                  =   mean(f(BaselineIndex));
    f                       =   f   -   f_zero;
end

%% determining the formating parameters
switch Output
    case 'Screen'
        
        Units               =   'normalized';
        Position            =   [   0   ,   0   ,   1   ,   0.5     ];
        
        FontSizeS           =   10;
        FontSizeM           =   12;
        FontSizeL           =   16;
        
        LineWidthS          =   1;
        LineWidthL          =   2;
        MarkerSize          =   8;
        MarkerDensity       =   80;
        
        MajorGrid           =   'on';
        MinorGrid           =   'on';
        
    case 'Paper'
        
        Units               =   'centimeters';
        Position            =   [   50  ,   15  ,   16  ,   8       ];
        
        FontSizeS           =   6;
        FontSizeM           =   8;
        FontSizeL           =   10;
        
        LineWidthS          =   0.5;
        LineWidthL          =   1;
        MarkerSize          =   5;
        MarkerDensity       =   20;
        
        MajorGrid           =   'off';
        MinorGrid           =   'off';
        
end

%% Creating the figure if none was used as an input

if isempty(FreqAxis)
    % creating a figure and setting its size and subplots
    fig             =   figure;
    fig.Units       =   Units;
    fig.Position    =   Position;
    
    % getting hanlde for the current axis
    FreqAxis        =   gca;
    
    % creating an emply legend cell array
    CurrentLegendLabel = [];
else
    CurrentLegend       =   findobj(gcf, 'Type', 'Legend');
    if isempty(CurrentLegend)
        CurrentLegendLabel  =   [];
    else
        CurrentLegendLabel  =   CurrentLegend.String;
    end
end

%% Creating color maps and markers to be used for ploting
% Blue colormaps for the different overtones
blue_colormap   =   [   0   ,   25  ,   102 ; ...
                        0   ,   37  ,   153 ; ...
                        0   ,   50  ,   204 ; ...
                        0   ,   62  ,   255 ; ...
                        64  ,   110 ,   255 ;...
                        128 ,   159 ,   255 ;...
                        191 ,   207 ,   255];

blue_colormap   =   blue_colormap/255;

LineMarker      =   {   '^' ,   ...
                        'v' ,   ...
                        'o' ,   ...
                        's' ,   ...
                        'd' ,   ...
                        '>' ,   ...
                        '<' };

if isempty(ColorMarkerNumber)
    ColorMarkerNumber   =   OvertoneIndex/2;
end

%% plotting the data
axes(FreqAxis);
hold on;
LineHandle  =   plot(   Time                ,   f                                                               ,   ...
                        'Color'             ,   blue_colormap   (   ColorMarkerNumber   ,   :   )               ,   ...
                        'LineWidth'         ,   LineWidthL                                                      ,   ...
                        'LineStyle'         ,   '-'                                                             ,   ...
                        'Marker'            ,   LineMarker      {   ColorMarkerNumber   }                       ,   ...
                        'MarkerEdgeColor'   ,   blue_colormap   (   ColorMarkerNumber   ,   :   )               ,   ...
                        'MarkerFaceColor'   ,   'w'                                                             ,   ...
                        'MarkerSize'        ,   MarkerSize                                                      ,   ...
                        'MarkerIndices'     ,   1 : round( length( Time ) / MarkerDensity ) : length( Time )    );

    
%% figure formating 
% axes properties
% grid
FreqAxis.XGrid                          =   MajorGrid; 
FreqAxis.XMinorGrid                     =   MinorGrid;
FreqAxis.YGrid                          =   MajorGrid; 
FreqAxis.YMinorGrid                     =   MinorGrid;

FreqAxis.Box                            =   'off';
FreqAxis.LineWidth                      =   LineWidthS;
FreqAxis.FontName                       =   'Helvetica';
FreqAxis.FontSize                       =   FontSizeM;

% y-axis properties
FreqAxis.YLabel.Interpreter             =   'latex';
FreqAxis.YLabel.String                  =   axis_label;
FreqAxis.YLabel.FontSize                =   FontSizeL;
FreqAxis.YMinorTick                     =   'on';

% x-axis properties
FreqAxis.XLim                           =   [   min(Time)   ,   max(Time)   ];
FreqAxis.XDir                           =   'normal';
FreqAxis.XLabel.Interpreter             =   'latex';
FreqAxis.XLabel.String                  =   'Time [$min$]';
FreqAxis.XLabel.FontSize                =   FontSizeL;
FreqAxis.XAxis.MinorTickValuesMode      =   'manual';
FreqAxis.XMinorTick                     =   'on';

% defining the tick positions to make sense for time axis
ticksLowerlimit     =   (   round(  min(    Time    )   /   600  )   -   1  )   *   600;
ticksUpperlimit     =   (   round(  max(    Time    )   /   600  )   +   1  )   *   600;

if max(Time) - min(Time) < 50
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   5   :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   1   :   ticksUpperlimit;

elseif max(Time) - min(Time) < 100
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   20  :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   5   :   ticksUpperlimit;
    
elseif max(Time) - min(Time) < 200
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   30  :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   10  :   ticksUpperlimit;
    
elseif max(Time) - min(Time) < 400        
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   60  :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   20  :   ticksUpperlimit;
    
elseif max(Time) - min(Time) < 1000        
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   120 :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   30  :   ticksUpperlimit;
    
elseif max(Time) - min(Time) < 1200        
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   180 :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   30  :   ticksUpperlimit;
    
elseif max(Time) - min(Time) < 1600        
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   240 :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   60  :   ticksUpperlimit;
    
else
    
    FreqAxis.XTick                      =   ticksLowerlimit     :   600 :   ticksUpperlimit;
    FreqAxis.XAxis.MinorTickValues      =   ticksLowerlimit     :   60  :   ticksUpperlimit;
    
end

%% Adding Legend
NewLegendLabel                  =   [   CurrentLegendLabel  ,   legend_label    ];
legend(NewLegendLabel);

FreqAxis.Legend.Interpreter     =   'latex';
FreqAxis.Legend.Location        =   'northeast';
FreqAxis.Legend.FontSize        =   FontSizeM;
FreqAxis.Legend.Box             =   'on';
FreqAxis.Legend.LineWidth       =   LineWidthS;

end