classdef nu_analytics_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        ImportingDataPanel           matlab.ui.container.Panel
        HTML                         matlab.ui.control.HTML
        ImportDataButton             matlab.ui.control.Button
        CalculatingShiftsPanel       matlab.ui.container.Panel
        OvertoneforplottingDropDownLabel  matlab.ui.control.Label
        Overtone                     matlab.ui.control.DropDown
        Solution1egD2OLabel          matlab.ui.control.Label
        densitygcm3EditFieldLabel    matlab.ui.control.Label
        rho_sol_1                    matlab.ui.control.NumericEditField
        viscosity102gcm1sec1Label    matlab.ui.control.Label
        eta_sol_1                    matlab.ui.control.NumericEditField
        Solution2eg455wtglycerolinH2OLabel  matlab.ui.control.Label
        densitygcm3EditField_2Label  matlab.ui.control.Label
        rho_sol_2                    matlab.ui.control.NumericEditField
        viscosity102gcm1sec1EditField_2Label  matlab.ui.control.Label
        eta_sol_2                    matlab.ui.control.NumericEditField
        CalculateShiftsButton        matlab.ui.control.Button
        ResultsPanel                 matlab.ui.container.Panel
        Sol1Table                    matlab.ui.control.Table
        AdsorbateresponseinSolution1Label  matlab.ui.control.Label
        Sol2Table                    matlab.ui.control.Table
        AdsorbateresponseinSolution2Label  matlab.ui.control.Label
        ExtrapolatedTable            matlab.ui.control.Table
        Extrapolatedresponseat0and0Label  matlab.ui.control.Label
        MeasuredTable                matlab.ui.control.Table
        MeasuredresponesLabel        matlab.ui.control.Label
    end

    
    properties (Access = private)
        data_table = table % table containing the QCM-D data
        normalized % variable defined by the user is the imported data 
                   % are normalized or not
        
        fResults = table % table containing the frequency results
        DResults = table % table containing the dissipation results
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %app.UITable_DataInput.Data = data_table;
        end

        % Button pushed function: ImportDataButton
        function ImportDataButtonPushed(app, event)
            
            % obtaining file name with path
            [ data_file , data_path ] = uigetfile('*.txt');
            full_data_file = fullfile(data_path , data_file);
            
            % read the file and convert it to table
            app.data_table = readtable(full_data_file);
            
            % rename the variables
            app.data_table.Properties.VariableNames  =   {  'Time'                  , ...
                                                        'f1_1'      ,   'D1'    , ...
                                                        'f3_3'      ,   'D3'    , ...
                                                        'f5_5'      ,   'D5'    , ...
                                                        'f7_7'      ,   'D7'    , ...
                                                        'f9_9'      ,   'D9'    , ...
                                                        'f11_11'    ,   'D11'   , ...
                                                        'f13_13'    ,   'D13'   };
            
            
            app.normalized   =   questdlg(  'Please select the form of the frequency in the data file!'     , ...
                                            'Frequency data'                                                , ...
                                            'ÿf_n or f_n'   ,   'ÿf_n/n or f_n/n'                           , ...
                                            'ÿf_n/n or f_n/n'                                               );
            waitfor (   app.normalized   );

            switch app.normalized
                case 'ÿf_n or f_n'
                                  
                    app.data_table.f3_3 = app.data_table.f3_3/3;
                    app.data_table.f5_5 = app.data_table.f5_5/5;
                    app.data_table.f7_7 = app.data_table.f7_7/7;
                    app.data_table.f9_9 = app.data_table.f9_9/9;
                    app.data_table.f11_11 = app.data_table.f11_11/11;
                    app.data_table.f13_13 = app.data_table.f13_13/13;  
                            
            end


            

            
            % convert time to minutes
            if app.data_table.Time(2) - app.data_table.Time(1) >1
                app.data_table.Time = app.data_table.Time/60;
            end
            
            
            % add variables description
            app.data_table.Properties.VariableDescriptions   =   {  'Time'                                                                      , ...
                                                                'fundemental tone freq.'                    ,   'fundemental tone dissip.'  , ...
                                                                'normalized freq. at the 3rd overtone'      ,   '3rd overtone dissip.'      , ...
                                                                'normalized freq. at the 5th overtone'      ,   '5th overtone dissip.'      , ...
                                                                'normalized freq. at the 7th overtone'      ,   '7th overtone dissip.'      , ...
                                                                'normalized freq. at the 9th overtone'      ,   '9th overtone dissip.'      , ...
                                                                'normalized freq. at the 11th overtone'     ,   '11th overtone dissip.'     , ...
                                                                'normalized freq. at the 13th overtone'     ,   '13th overtone dissip.'     };
            
            app.data_table.Properties.VariableUnits          =   {  'min'                                                                       , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              , ...
                                                                'Hz'                                ,   '1e-6'                              };
            
        end

        % Button pushed function: CalculateShiftsButton
        function CalculateShiftsButtonPushed(app, event)
             [app.fResults , app.DResults] =  nu_QCMDshifts_table(   app.data_table   ,   str2double(app.Overtone.Value)   , app.rho_sol_1.Value , app.eta_sol_1.Value , app.rho_sol_2.Value , app.eta_sol_2.Value);
            
            t = table;
            t{1,:} = app.fResults{1,:};
            t{2,:} = app.DResults{1,:};
            t{3,:} = app.fResults{2,:};
            t{4,:} = app.DResults{2,:};
            t{5,:} = app.fResults{3,:};
            t{6,:} = app.DResults{3,:};
            t{7,:} = app.fResults{4,:};
            t{8,:} = app.DResults{4,:};
            t{9,:} = app.fResults{5,:};
            t{10,:} = app.DResults{5,:};
            app.MeasuredTable.Data = t;
            
            t = table;
            t{1,:} = app.fResults{6,:};
            t{2,:} = app.DResults{6,:};
            app.Sol1Table.Data = t;
            
            t = table;
            t{1,:} = app.fResults{7,:};
            t{2,:} = app.DResults{7,:};
            app.Sol2Table.Data = t;
            
            t = table;
            t{1,:} = app.fResults{8,:};
            t{2,:} = app.DResults{8,:};
            app.ExtrapolatedTable.Data = t;
            
            nu_QCMDextrapolation_fig( app.fResults , app.DResults )
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 952 549];
            app.UIFigure.Name = 'MATLAB App';

            % Create ImportingDataPanel
            app.ImportingDataPanel = uipanel(app.UIFigure);
            app.ImportingDataPanel.TitlePosition = 'centertop';
            app.ImportingDataPanel.Title = '1. Importing Data';
            app.ImportingDataPanel.FontWeight = 'bold';
            app.ImportingDataPanel.FontSize = 16;
            app.ImportingDataPanel.Position = [1 343 325 207];

            % Create HTML
            app.HTML = uihtml(app.ImportingDataPanel);
            app.HTML.HTMLSource = '<ul>  <li>Data file should be a Tab-delimited .txt;</li>  <li>columns in the following order: <br> Time, ÿf<sub>1</sub>, ÿD<sub>1</sub>, ÿf<sub>3</sub>, ÿD<sub>3</sub>, ÿf<sub>5</sub>, ÿD<sub>5</sub>, ÿf<sub>7</sub>, ÿD<sub>7</sub>, ÿf<sub>9</sub>, ÿD<sub>9</sub>, ÿf<sub>11</sub>, ÿD<sub>11</sub>, ÿf<sub>13</sub>, ÿD<sub>13</sub>;<li>with/without a header row.</li></ul>';
            app.HTML.Tooltip = {''};
            app.HTML.Position = [0 43 320 118];

            % Create ImportDataButton
            app.ImportDataButton = uibutton(app.ImportingDataPanel, 'push');
            app.ImportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportDataButtonPushed, true);
            app.ImportDataButton.FontWeight = 'bold';
            app.ImportDataButton.Position = [113 13 100 23];
            app.ImportDataButton.Text = 'Import Data';

            % Create CalculatingShiftsPanel
            app.CalculatingShiftsPanel = uipanel(app.UIFigure);
            app.CalculatingShiftsPanel.TitlePosition = 'centertop';
            app.CalculatingShiftsPanel.Title = '2. Calculating Shifts';
            app.CalculatingShiftsPanel.FontWeight = 'bold';
            app.CalculatingShiftsPanel.FontSize = 16;
            app.CalculatingShiftsPanel.Position = [1 0 326 344];

            % Create OvertoneforplottingDropDownLabel
            app.OvertoneforplottingDropDownLabel = uilabel(app.CalculatingShiftsPanel);
            app.OvertoneforplottingDropDownLabel.HorizontalAlignment = 'right';
            app.OvertoneforplottingDropDownLabel.Position = [48 282 116 22];
            app.OvertoneforplottingDropDownLabel.Text = 'Overtone for plotting';

            % Create Overtone
            app.Overtone = uidropdown(app.CalculatingShiftsPanel);
            app.Overtone.Items = {'1', '3', '5', '7', '9', '11', '13'};
            app.Overtone.ItemsData = {'1', '3', '5', '7', '9', '11', '13'};
            app.Overtone.Position = [179 282 100 22];
            app.Overtone.Value = '3';

            % Create Solution1egD2OLabel
            app.Solution1egD2OLabel = uilabel(app.CalculatingShiftsPanel);
            app.Solution1egD2OLabel.FontWeight = 'bold';
            app.Solution1egD2OLabel.Position = [98 238 132 22];
            app.Solution1egD2OLabel.Text = 'Solution #1 (e.g., D2O)';

            % Create densitygcm3EditFieldLabel
            app.densitygcm3EditFieldLabel = uilabel(app.CalculatingShiftsPanel);
            app.densitygcm3EditFieldLabel.HorizontalAlignment = 'right';
            app.densitygcm3EditFieldLabel.Position = [8 207 105 22];
            app.densitygcm3EditFieldLabel.Text = 'density [g.cm^(-3)]';

            % Create rho_sol_1
            app.rho_sol_1 = uieditfield(app.CalculatingShiftsPanel, 'numeric');
            app.rho_sol_1.Position = [219 207 100 22];
            app.rho_sol_1.Value = 1.10436;

            % Create viscosity102gcm1sec1Label
            app.viscosity102gcm1sec1Label = uilabel(app.CalculatingShiftsPanel);
            app.viscosity102gcm1sec1Label.HorizontalAlignment = 'right';
            app.viscosity102gcm1sec1Label.Position = [8 171 196 22];
            app.viscosity102gcm1sec1Label.Text = 'viscosity [10^-2 g.cm^(-1).sec^(-1)]';

            % Create eta_sol_1
            app.eta_sol_1 = uieditfield(app.CalculatingShiftsPanel, 'numeric');
            app.eta_sol_1.Position = [219 171 100 22];
            app.eta_sol_1.Value = 1.094;

            % Create Solution2eg455wtglycerolinH2OLabel
            app.Solution2eg455wtglycerolinH2OLabel = uilabel(app.CalculatingShiftsPanel);
            app.Solution2eg455wtglycerolinH2OLabel.FontWeight = 'bold';
            app.Solution2eg455wtglycerolinH2OLabel.Position = [48 130 252 22];
            app.Solution2eg455wtglycerolinH2OLabel.Text = 'Solution #2 (e.g., 4.55%wt. glycerol in H2O)';

            % Create densitygcm3EditField_2Label
            app.densitygcm3EditField_2Label = uilabel(app.CalculatingShiftsPanel);
            app.densitygcm3EditField_2Label.HorizontalAlignment = 'right';
            app.densitygcm3EditField_2Label.Position = [8 101 105 22];
            app.densitygcm3EditField_2Label.Text = 'density [g.cm^(-3)]';

            % Create rho_sol_2
            app.rho_sol_2 = uieditfield(app.CalculatingShiftsPanel, 'numeric');
            app.rho_sol_2.Position = [219 101 100 22];
            app.rho_sol_2.Value = 1.00785258320999;

            % Create viscosity102gcm1sec1EditField_2Label
            app.viscosity102gcm1sec1EditField_2Label = uilabel(app.CalculatingShiftsPanel);
            app.viscosity102gcm1sec1EditField_2Label.HorizontalAlignment = 'right';
            app.viscosity102gcm1sec1EditField_2Label.Position = [8 65 196 22];
            app.viscosity102gcm1sec1EditField_2Label.Text = 'viscosity [10^-2 g.cm^(-1).sec^(-1)]';

            % Create eta_sol_2
            app.eta_sol_2 = uieditfield(app.CalculatingShiftsPanel, 'numeric');
            app.eta_sol_2.Position = [219 65 100 22];
            app.eta_sol_2.Value = 0.998411558918983;

            % Create CalculateShiftsButton
            app.CalculateShiftsButton = uibutton(app.CalculatingShiftsPanel, 'push');
            app.CalculateShiftsButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateShiftsButtonPushed, true);
            app.CalculateShiftsButton.FontWeight = 'bold';
            app.CalculateShiftsButton.Position = [109.5 16 105 23];
            app.CalculateShiftsButton.Text = 'Calculate Shifts';

            % Create ResultsPanel
            app.ResultsPanel = uipanel(app.UIFigure);
            app.ResultsPanel.TitlePosition = 'centertop';
            app.ResultsPanel.Title = '3. Results';
            app.ResultsPanel.FontWeight = 'bold';
            app.ResultsPanel.FontSize = 16;
            app.ResultsPanel.Position = [326 0 627 549];

            % Create Sol1Table
            app.Sol1Table = uitable(app.ResultsPanel);
            app.Sol1Table.ColumnName = {'n=1'; 'n=3'; 'n=5'; 'n=7'; 'n=9'; 'n=11'; 'n=13'};
            app.Sol1Table.RowName = {'ÿf_n/n'; 'ÿD_n'};
            app.Sol1Table.Position = [10 220 601 71];

            % Create AdsorbateresponseinSolution1Label
            app.AdsorbateresponseinSolution1Label = uilabel(app.ResultsPanel);
            app.AdsorbateresponseinSolution1Label.FontWeight = 'bold';
            app.AdsorbateresponseinSolution1Label.Position = [213 294 203 22];
            app.AdsorbateresponseinSolution1Label.Text = 'Adsorbate response in Solution #1';

            % Create Sol2Table
            app.Sol2Table = uitable(app.ResultsPanel);
            app.Sol2Table.ColumnName = {'n=1'; 'n=3'; 'n=5'; 'n=7'; 'n=9'; 'n=11'; 'n=13'};
            app.Sol2Table.RowName = {'ÿf_n/n'; 'ÿD_n'};
            app.Sol2Table.Position = [10 117 601 71];

            % Create AdsorbateresponseinSolution2Label
            app.AdsorbateresponseinSolution2Label = uilabel(app.ResultsPanel);
            app.AdsorbateresponseinSolution2Label.FontWeight = 'bold';
            app.AdsorbateresponseinSolution2Label.Position = [213 192 203 22];
            app.AdsorbateresponseinSolution2Label.Text = 'Adsorbate response in Solution #2';

            % Create ExtrapolatedTable
            app.ExtrapolatedTable = uitable(app.ResultsPanel);
            app.ExtrapolatedTable.ColumnName = {'n=1'; 'n=3'; 'n=5'; 'n=7'; 'n=9'; 'n=11'; 'n=13'};
            app.ExtrapolatedTable.RowName = {'ÿf_n/n'; 'ÿD_n'};
            app.ExtrapolatedTable.Position = [9 7 602 71];

            % Create Extrapolatedresponseat0and0Label
            app.Extrapolatedresponseat0and0Label = uilabel(app.ResultsPanel);
            app.Extrapolatedresponseat0and0Label.FontWeight = 'bold';
            app.Extrapolatedresponseat0and0Label.Position = [195 83 238 22];
            app.Extrapolatedresponseat0and0Label.Text = 'Extrapolated response at ÿ = 0 and ÿ = 0';

            % Create MeasuredTable
            app.MeasuredTable = uitable(app.ResultsPanel);
            app.MeasuredTable.ColumnName = {'n=1'; 'n=3'; 'n=5'; 'n=7'; 'n=9'; 'n=11'; 'n=13'};
            app.MeasuredTable.RowName = {'ÿf_n/n (Solution #1 before)'; 'ÿD_n (Solution #1 before)'; 'ÿf_n/n (Solution #2 before)'; 'ÿD_n (Solution #2 before)'; 'ÿf_n/n (adsorbate)'; 'ÿD_n (adsorbate)'; 'ÿf_n/n (Solution #1 after)'; 'ÿD_n (Solution #1 after)'; 'ÿf_n/n (Solution #2 after)'; 'ÿD_n (Solution #2 after)'};
            app.MeasuredTable.Position = [11 328 601 163];

            % Create MeasuredresponesLabel
            app.MeasuredresponesLabel = uilabel(app.ResultsPanel);
            app.MeasuredresponesLabel.FontWeight = 'bold';
            app.MeasuredresponesLabel.Position = [255 495 119 22];
            app.MeasuredresponesLabel.Text = 'Measured respones';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = nu_analytics_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end