classdef GUI < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        ListBoxLabel  matlab.ui.control.Label
        ListBox       matlab.ui.control.ListBox
        ImportBtn   matlab.ui.control.Button
        PlayBtn       matlab.ui.control.Button
        TabGroup      matlab.ui.container.TabGroup
        ASTab         matlab.ui.container.Tab
        UIAxesAS      matlab.ui.control.UIAxes
        PSTab         matlab.ui.container.Tab
        UIAxesPS      matlab.ui.control.UIAxes
        TitleAudio    matlab.ui.control.Label
        % Global List
        List
        %Global Last Value List Box
        LastValueLB
        %Gloabal Player
        Player
        %Global Exist File
        ExistFile
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            value = app.ListBox.Value;
        end

        % Button pushed function: ImportarBtn
        % alínea 2: importa ficheiros .mp3 ou .wav.
        function ImportBtnButtonPushed(app, event)
            %Para o áudio anterior
            if app.LastValueLB == 1
                stop(app.Player);
            end
            [filename, filepath] = uigetfile({'*.mp3;*.wav', 'Audio Files (*.wav,*.mp3)'});
            %Verifica se foi escolhido algum ficheiro
            if filename ~= 0
                %Chama a função para verificar se o ficheiro já se encontra
                %na lista.
                app.ExistFile = VerifyFile(app, filename);
                %Se o ficheiro não existir adiciona à List Box e à Lista
                %que contém o nome e o diretório do ficheiro.
                if app.ExistFile ~= 1
                    n=length(app.ListBox.Items)+1;
                    app.ListBox.Items{n} = filename;
                    app.List{n} = {filename, filepath};
                    disp('Added file');
                end
            end
        end
        
        %Função para verificar se o ficheiro já existe
        function existFile = VerifyFile(app, fileName)
            %Procura o ficheiro já existe
            for x=1:length(app.ListBox.Items)
                existFile = strcmp(fileName, app.List{x}{1});
                if existFile == 1
                    disp('File already exists');
                    return;
                end
            end
        end
        
        % Button pushed function: PlayBtn
        % alínea 3: play do sinal que é importado
        function PlayButtonPushed(app, event)
            n = length(app.List);
            %Para o áudio anterior
            if app.LastValueLB == 1
                stop(app.Player);
            end
            for x=1:n
                existFile = strcmp(app.ListBox.Value, app.List{x}{1});
                if existFile == 1
                    fileName = strcat(app.List{x}{2}, app.List{x}{1});
                    app.TitleAudio.Text = string(app.List{x}{1});
                    % Read in the standard demo wave file that ships with MATLAB.
                    [Y, Fs] = audioread(fileName);
                    %soundsc(y, fs);
                    app.Player = audioplayer(Y,Fs);
                    play(app.Player)
                    % Plot the original waveform.
                    plot(app.UIAxesAS ,Y, 'b-');
                    drawnow;
                    app.LastValueLB = app.ListBox.Value;
                    break
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 720 450];
            app.UIFigure.Name = 'Áudio Voz App';

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

            % Create ImportBtn
            app.ImportBtn = uibutton(app.UIFigure, 'push');
            app.ImportBtn.ButtonPushedFcn = createCallbackFcn(app, @ImportBtnButtonPushed, true);
            app.ImportBtn.Position = [541 50 100 22];
            app.ImportBtn.Text = 'Import';

            % Create PlayBtn
            app.PlayBtn = uibutton(app.UIFigure, 'push');
            app.PlayBtn.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayBtn.Position = [189 50 100 22];
            app.PlayBtn.Text = 'Play';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [14 95 450 251];

            % Create ASTab
            app.ASTab = uitab(app.TabGroup);
            app.ASTab.Title = 'Audio Signal';

            % Create UIAxesAS
            app.UIAxesAS = uiaxes(app.ASTab);
            title(app.UIAxesAS, 'Audio Signal')
            xlabel(app.UIAxesAS, 'X')
            ylabel(app.UIAxesAS, 'Y')
            app.UIAxesAS.PlotBoxAspectRatio = [2.94957983193277 1 1];
            app.UIAxesAS.Position = [1 1 448 225];

            % Create PSTab
            app.PSTab = uitab(app.TabGroup);
            app.PSTab.Title = 'Power Spectrum';

            % Create UIAxesPS
            app.UIAxesPS = uiaxes(app.PSTab);
            title(app.UIAxesPS, 'Audio Signal Power Spectrum')
            xlabel(app.UIAxesPS, 'X')
            ylabel(app.UIAxesPS, 'Y')
            app.UIAxesPS.PlotBoxAspectRatio = [2.94957983193277 1 1];
            app.UIAxesPS.Position = [1 1 448 225];

            % Create TitleAudio
            app.TitleAudio = uilabel(app.UIFigure);
            app.TitleAudio.HorizontalAlignment = 'center';
            app.TitleAudio.Position = [15 380 448 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
            
            app.List = {{'handel_J.wav', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\'}, {'v_female (1).mp3', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\voices\female\'}, {'v_male (2).mp3', 'C:\Users\AAMS\Documents\PS\TP\Matlab Data\voices\male\'}};
            app.LastValueLB = 0;
            app.Player = 0;
            app.ExistFile = 0;
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