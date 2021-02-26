function [fResults , DResults]   =   ...
                    nu_QCMDshifts_table(   TableName   ,   Overtone   , sol_1_rho , sol_1_eta , sol_2_rho , sol_2_eta)
% 
% This function calcultates of the shift of an adsorbate in two solutions
% with the same kinematic viscosity, it also calculates the extrapolation 
% from these two solutions to \rho = 0 and \eta = 0
%
% "fResults" ...
%       ... a table containing all the frequency shifts
%
% "DResults" ...
%       ... a table containing all the dissipation shifts
%
% Inputs
%
% "TableName" ...
%       ... is the table containing the QCM-D data
%
% "Overtone" ...
%       ... is the overtone number to plot
%
% "sol_1_rho" ...
%       ... is the density of solution #1
%
% "sol_1_eta" ...
%       ... is the viscosity of solution #1
%
% "sol_2_rho" ...
%       ... is the density of solution #2
%
% "sol_2_eta" ...
%       ... is the viscosity of solution #2

%% selecting the data and calculating the responses

ax_f = nu_QCMDonefplot_table(   TableName   ,   Overtone );

sol_name    =   {   'Solution #1 before adsorbate'  ; ...
                    'Solution #2 before adsorbate'  ; ...
                    'adsorbate'                     ; ...
                    'Solution #1 after adsorbate'   ; ...
                    'Solution #2 after adsorbate'   };
                
message_ref =   {   'Solution #1 before adsorbate: ... select few data points just before or after the solution response'  ; ...
                    'Solution #2 before adsorbate: ... select few data points just before or after the solution response'  ; ...
                    'adsorbate: ... select few data points just before the adsorbate response'                     ; ...
                    'Solution #1 after adsorbate: ... select few data points just before or after the solution response'   ; ...
                    'Solution #2 after adsorbate: ... select few data points just before or after the solution response'   };
                
message_sol =   {   'Solution #1 before adsorbate: ... select few data points representing the solution response'  ; ...
                    'Solution #2 before adsorbate: ... select few data points representing the solution response'  ; ...
                    'adsorbate: ... select few data points after the adsorbate response'                     ; ...
                    'Solution #1 after adsorbate: ... select few data points representing the solution response'   ; ...
                    'Solution #2 after adsorbate: ... select few data points representing the solution response'   };

fResults = table;
DResults = table;

for s = 1:5
   
        
        ax_f.Title.String   =   sol_name{s};
        
 
        
        ax      =   gca;
        
        % using the 5th overtone to select the data
        l       =   findobj(    gca , ...
                                'Type'          ,   'line'              );
        
        % Giving the option to repeat the whole selection and analysis step
        repeatAnalysis  =   'Repeat'    ;
        
        [   ~   ,   ~  ,   ~  ,   Ref_pIndex  ]   =   nu_selectRectangle(    'XDataSource'   ,   l.XData'                            , ...
                                                                                        'YDataSource'   ,   l.YData'                            , ...
                                                                                        'Message'       ,   message_ref{s}  );
                                                                      
        [   ~   ,   ~  ,   ~  ,   Sol_pIndex  ]   =   nu_selectRectangle(    'XDataSource'   ,   l.XData'                            , ...
                                                                                        'YDataSource'   ,   l.YData'                            , ...
                                                                                        'Message'       ,   message_sol{s}   );
                                                                                    
                                                                                    
        fResults{s,1} = - mean(TableName.f1_1(Ref_pIndex)) + mean(TableName.f1_1(Sol_pIndex));
        fResults{s,2} = - mean(TableName.f3_3(Ref_pIndex)) + mean(TableName.f3_3(Sol_pIndex));
        fResults{s,3} = - mean(TableName.f5_5(Ref_pIndex)) + mean(TableName.f5_5(Sol_pIndex));
        fResults{s,4} = - mean(TableName.f7_7(Ref_pIndex)) + mean(TableName.f7_7(Sol_pIndex));
        fResults{s,5} = - mean(TableName.f9_9(Ref_pIndex)) + mean(TableName.f9_9(Sol_pIndex));
        fResults{s,6} = - mean(TableName.f11_11(Ref_pIndex)) + mean(TableName.f11_11(Sol_pIndex));
        fResults{s,7} = - mean(TableName.f13_13(Ref_pIndex)) + mean(TableName.f13_13(Sol_pIndex));
        
        DResults{s,1} = - mean(TableName.D1(Ref_pIndex)) + mean(TableName.D1(Sol_pIndex));
        DResults{s,2} = - mean(TableName.D3(Ref_pIndex)) + mean(TableName.D3(Sol_pIndex));
        DResults{s,3} = - mean(TableName.D5(Ref_pIndex)) + mean(TableName.D5(Sol_pIndex));
        DResults{s,4} = - mean(TableName.D7(Ref_pIndex)) + mean(TableName.D7(Sol_pIndex));
        DResults{s,5} = - mean(TableName.D9(Ref_pIndex)) + mean(TableName.D9(Sol_pIndex));
        DResults{s,6} = - mean(TableName.D11(Ref_pIndex)) + mean(TableName.D11(Sol_pIndex));
        DResults{s,7} = - mean(TableName.D13(Ref_pIndex)) + mean(TableName.D13(Sol_pIndex));

           
            
end

% rename the variables
fResults.Properties.VariableNames  =   {    'f1_1'      , ...
                                            'f3_3'      , ...
                                            'f5_5'      , ...
                                            'f7_7'      , ...
                                            'f9_9'      , ...
                                            'f11_11'    , ...
                                            'f13_13'    };
                                    
DResults.Properties.VariableNames  =   {    'D1'    , ...
                                            'D3'    , ...
                                            'D5'    , ...
                                            'D7'    , ...
                                            'D9'    , ...
                                            'D11'   , ...
                                            'D13'   };

fResults{6,:} = fResults{3,:} + (fResults{4,:} - fResults{1,:});
fResults{7,:} = fResults{3,:} + (fResults{5,:} - fResults{2,:});

DResults{6,:} = DResults{3,:} + (DResults{4,:} - DResults{1,:});
DResults{7,:} = DResults{3,:} + (DResults{5,:} - DResults{2,:});

fResults{8,:} = fResults{6,:} - (fResults{6,:} - fResults{7,:}) ./ (sol_1_rho -  sol_2_rho) .* sol_1_rho;
DResults{8,:} = DResults{6,:} - (DResults{6,:} - DResults{7,:}) ./ (sol_1_eta -  sol_2_eta) .* sol_1_eta;
 
     
end

