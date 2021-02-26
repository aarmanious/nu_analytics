
function     nu_QCMDextrapolation_fig( fResults , DResults )
                        
%A function to plot the extrapolation data at different overtones

%% default properties of the plot
set(    groot   ,   'defaultLegendItemTokenSize'    ,   [ 15 30 ]   );
set(    groot   ,  'defaultTextInterpreter'         ,   'latex'     );


 
 

%% creating a figure

Fig_Width       =   16.00;  % cm
Fig_Height      =   6.00;   % cm

Fig_ExtrapolationNPs           =   figure;
Fig_ExtrapolationNPs.Units     =   'centimeters';
Fig_ExtrapolationNPs.Position  =   [   10   10   Fig_Width   Fig_Height ];

ax_Position         =   nu_axPositionCenti(     Fig_Width       ,   Fig_Height                      , ...
                                                1.35            ,   0.15                            , ...
                                                0.9             ,   0.4                             , ...
                                                [ 6.5 , 6.5 ]   ,   [   2.0     3.6     ]   );

% f dry overtone
ax_fOvertone        =   axes(   'Units'     ,   'centimeters'           , ...
                                'Position'  ,   [1.35 0.9 6.5 4.75 ]);

% D Mech Overtone
ax_DOvertone        =   axes(   'Units'     ,   'centimeters'           , ...
                                'Position'  ,   [9.35 0.9 6.5 4.75 ] );



%% plotting the data  

axes(ax_fOvertone)

hold on 
    
scatter_fOvertone(1)    =   scatter(    [3:2:11]                        ,  fResults{3 , 2:6 }       , ...
                                        75                                                          , ...
                                        'LineWidth'                     ,   0.5                     , ...
                                        'Marker'                        ,   'd'                     , ... 
                                        'MarkerEdgeColor'               ,   [ 0.5 , 0.5 , 0.5 ]     , ...
                                        'MarkerFaceAlpha'               ,   0.25                    , ...
                                        'MarkerFaceColor'               ,   [ 0.5 , 0.5 , 0.5 ]     ); 
hold on
    
scatter_fOvertone(2)    =   scatter(    [3:2:11]                           ,  fResults{8 , 2:6 }           , ...
                                        75                                                              , ...
                                        'LineWidth'                     ,   0.5                         , ...
                                        'Marker'                        ,   'o'                         , ... 
                                        'MarkerEdgeColor'               ,   [ 0.466 , 0.674 , 0.188 ]   , ...
                                        'MarkerFaceAlpha'               ,   0                           , ...
                                        'MarkerFaceColor'               ,   [ 0.466 , 0.674 , 0.188 ]   );


%% adding legend

LegendLabel     =   {   '$\Delta f \; \mathrm{(measured)}$'    ; ...
                        '$\Delta f_\mathrm{\rho = 0}$'         }; 

    
l_f_Overtone   =   legend(    [ scatter_fOvertone(1) , scatter_fOvertone(2) ]    ,   LegendLabel     );

l_f_Overtone.Interpreter    =   'latex';
l_f_Overtone.FontSize       =   6;
l_f_Overtone.Location       =   'southwest';
l_f_Overtone.Box            =   'off';
l_f_Overtone.AutoUpdate     =   'off';




%% formating axis
   
ax_fOvertone.Box                =   'off';

ax_fOvertone.FontSize           =   6;

ax_fOvertone.XLim               =   [   2.5  ,   11.5  ];

ax_fOvertone.YDir   =   'reverse';

if ax_fOvertone.YLim(2) < 0
    YUpperLim           =   0;
else
    YUpperLim   =   round( ax_fOvertone.YLim(2)+49 , -2 );
end

ax_fOvertone.YLim(2)            =   YUpperLim;

ax_fOvertone.YTickMode          =   'auto';
ax_fOvertone.YMinorTick         =   'on';
ax_fOvertone.XGrid              =   'on';
ax_fOvertone.YGrid              =   'on';
ax_fOvertone.YTickLabelMode     =   'auto';


ax_fOvertone.YAxis.FontSize      =   8;
ax_fOvertone.XAxis.FontSize      =   8;

ax_fOvertone.XLabel.Interpreter =   'latex';
ax_fOvertone.YLabel.Interpreter =   'latex';

ax_fOvertone.XLabel.String      =   'Overtones ($n$)';
ax_fOvertone.YLabel.String      =   '$\Delta f_n / n \; [\mathrm{Hz}]$' ;

ax_fOvertone.XLabel.FontSize    =   10;
ax_fOvertone.YLabel.FontSize    =   10;

ax_fOvertone.XTick              =   3:2:11;
ax_fOvertone.XTickLabel         =   {    '3' , '5' , '7' , '9' , '11' };

% adding a guide line for df = zero 
GuideLine   =   yline( 0 );

GuideLine.Color         =   [ 0.75 0.75 0.75 ];
GuideLine.LineStyle     =   '-';
GuideLine.LineWidth     =   0.5;



%% plotting the data  

axes(ax_DOvertone)

hold on 
    
scatter_DOvertone(1)    =   scatter(    [3:2:11]                        ,  DResults{3 , 2:6 }       , ...
                                        75                                                          , ...
                                        'LineWidth'                     ,   0.5                     , ...
                                        'Marker'                        ,   'd'                     , ... 
                                        'MarkerEdgeColor'               ,   [ 0.5 , 0.5 , 0.5 ]     , ...
                                        'MarkerFaceAlpha'               ,   0.25                    , ...
                                        'MarkerFaceColor'               ,   [ 0.5 , 0.5 , 0.5 ]     ); 
hold on
    
scatter_DOvertone(2)    =   scatter(    [3:2:11]                           ,  DResults{8 , 2:6 }           , ...
                                        75                                                              , ...
                                        'LineWidth'                     ,   0.5                         , ...
                                        'Marker'                        ,   'o'                         , ... 
                                        'MarkerEdgeColor'               ,   [ 0.466 , 0.674 , 0.188 ]   , ...
                                        'MarkerFaceAlpha'               ,   0                           , ...
                                        'MarkerFaceColor'               ,   [ 0.466 , 0.674 , 0.188 ]   );


%% adding legend

LegendLabel     =   {   '$\Delta D \; \mathrm{(measured)}$'    ; ...
                        '$\Delta D_\mathrm{\eta = 0}$'         }; 

    
l_D_Overtone   =   legend(    [ scatter_DOvertone(1) , scatter_DOvertone(2) ]    ,   LegendLabel     );

l_D_Overtone.Interpreter    =   'latex';
l_D_Overtone.FontSize       =   6;
l_D_Overtone.Location       =   'southwest';
l_D_Overtone.Box            =   'off';
l_D_Overtone.AutoUpdate     =   'off';




%% formating axis
   
ax_DOvertone.Box                =   'off';

ax_DOvertone.FontSize           =   6;

ax_DOvertone.XLim               =   [   2.5  ,   11.5  ];


if ax_DOvertone.YLim(1) > 0
    YLowerLim           =   0;
else
    YLowerLim   =   round( ax_fOvertone.YLim(2)-49 , -2 );
end

ax_DOvertone.YLim(1)            =   YLowerLim;

ax_DOvertone.YTickMode          =   'auto';
ax_DOvertone.YMinorTick         =   'on';
ax_DOvertone.XGrid              =   'on';
ax_DOvertone.YGrid              =   'on';
ax_DOvertone.YTickLabelMode     =   'auto';


ax_DOvertone.YAxis.FontSize      =   8;
ax_DOvertone.XAxis.FontSize      =   8;

ax_DOvertone.XLabel.Interpreter =   'latex';
ax_DOvertone.YLabel.Interpreter =   'latex';

ax_DOvertone.XLabel.String      =   'Overtones ($n$)';
ax_DOvertone.YLabel.String      =   '$\Delta D_n \; [10^{-6}]$' ;

ax_DOvertone.XLabel.FontSize    =   10;
ax_DOvertone.YLabel.FontSize    =   10;

ax_DOvertone.XTick              =   3:2:11;
ax_DOvertone.XTickLabel         =   {    '3' , '5' , '7' , '9' , '11' };

% adding a guide line for df = zero 
GuideLine   =   yline( 0 );

GuideLine.Color         =   [ 0.75 0.75 0.75 ];
GuideLine.LineStyle     =   '-';
GuideLine.LineWidth     =   0.5;


end

