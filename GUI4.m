classdef GUI < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        ListBoxLabel  matlab.ui.control.Label
        ListBox       matlab.ui.control.ListBox
        ImportarBtn   matlab.ui.control.Button
        PlayBtn       matlab.ui.control.Button
        TabGroup      matlab.ui.container.TabGroup
        SATab         matlab.ui.container.Tab
        UIAxesSA      matlab.ui.control.UIAxes
        EPTab         matlab.ui.container.Tab
        UIAxesEP      matlab.ui.control.UIAxes
        TitleAudio    matlab.ui.control.Label
        % Global List
        List
        LastValueLB
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            value = app.ListBox.Value;
            
        end

        % Button pushed function: ImportarBtn
        % alínea 2: importa ficheiros .mp3 ou .wav
        function ImportarBtnButtonPushed(app, event)
            [filename, filepath] = uigetfile({'*.mp3;*.wav', 'Audio Files (*.wav,*.mp3)'});
            if filename ~= 0
                n=length(app.ListBox.Items)+1;
                app.ListBox.Items{n} = filename;
                app.List{n} = {filename, filepath};
            end
        end
        
        % Button pushed function: PlayBtn
        % alínea 3: play do sinal que é importado
        function PlayButtonPushed(app, event)
            n = length(app.List);
            if app.LastValueLB == 1
                %stop(player);
            end
            for x=1:n
                existFile = strcmp(app.ListBox.Value, app.List{x}{1});
                if existFile == 1
                    fileName = strcat(app.List{x}{2}, app.List{x}{1});
                    app.TitleAudio.Text = string(app.List{x}{1});
                    break
                end
            end
            if existFile == 1
                % Read in the standard demo wave file that ships with MATLAB.
                [Y, Fs] = audioread(fileName);
                %soundsc(y, fs);
                player = audioplayer(Y,Fs);
                play(player)
                % Plot the original waveform.
                plot(app.UIAxesSA ,Y, 'b-');
                drawnow;
                app.LastValueLB = app.ListBox.Value;
            end
            disp(app.List)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 720 450];
            app.UIFigure.Name = 'MATLAB App';

            % Create ListBoxLabel
            app.ListBoxLabel = uilabel(app.UIFigure);
            app.ListBoxLabel.HorizontalAlignment = 'right';
            app.ListBoxLabel.Position = [567 380 48 22];
            app.ListBoxLabel.Text = 'List Box';

            % Create ListBox
            app.ListBox = uilistbox(app.UIFigure);
            app.ListBox.Items = {'handel_J.wav', 'v_female (1).mp3', 'v_male (2).mp3'};
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [491 95 200 251];
            app.ListBox.Value = {};

            % Create ImportarBtn
            app.ImportarBtn = uibutton(app.UIFigure, 'push');
            app.ImportarBtn.ButtonPushedFcn = createCallbackFcn(app, @ImportarBtnButtonPushed, true);
            app.ImportarBtn.Position = [541 50 100 22];
            app.ImportarBtn.Text = 'Importar';

            % Create PlayBtn
            app.PlayBtn = uibutton(app.UIFigure, 'push');
            app.PlayBtn.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayBtn.Position = [189 50 100 22];
            app.PlayBtn.Text = 'Play';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [14 95 450 251];

            % Create SATab
            app.SATab = uitab(app.TabGroup);
            app.SATab.Title = 'Sinal áudio';

            % Create UIAxesSA
            app.UIAxesSA = uiaxes(app.SATab);
            title(app.UIAxesSA, 'Sinal Áudio')
            xlabel(app.UIAxesSA, 'X')
            ylabel(app.UIAxesSA, 'Y')
            app.UIAxesSA.PlotBoxAspectRatio = [2.94957983193277 1 1];
            app.UIAxesSA.Position = [1 1 448 225];

            % Create EPTab
            app.EPTab = uitab(app.TabGroup);
            app.EPTab.Title = 'Espetro de potência';

            % Create UIAxesEP
            app.UIAxesEP = uiaxes(app.EPTab);
            title(app.UIAxesEP, 'Espetro de Potência do Sinal de Áudio')
            xlabel(app.UIAxesEP, 'X')
            ylabel(app.UIAxesEP, 'Y')
            app.UIAxesEP.PlotBoxAspectRatio = [2.94957983193277 1 1];
            app.UIAxesEP.Position = [1 1 448 225];

            % Create TitleAudio
            app.TitleAudio = uilabel(app.UIFigure);
            app.TitleAudio.HorizontalAlignment = 'center';
            app.TitleAudio.Position = [15 380 448 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
            
            app.List = {{'handel_J.wav', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\'}, {'v_female (1).mp3', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\voices\female\'}, {'v_male (2).mp3', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\voices\male\'}};
            app.LastValueLB = 0;
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI
            
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
            clear all;
        end
    end
end