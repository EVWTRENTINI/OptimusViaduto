classdef otmsobre_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        SobreUIFigure     matlab.ui.Figure
        Image2            matlab.ui.control.Image
        Label_2           matlab.ui.control.Label
        Label             matlab.ui.control.Label
        Panel             matlab.ui.container.Panel
        GridLayout        matlab.ui.container.GridLayout
        PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel  matlab.ui.control.Label
        CENTRODECINCIASEXATASEDETECNOLOGIALabel  matlab.ui.control.Label
        UNIVERSIDADEFEDERALDESOCARLOSLabel  matlab.ui.control.Label
        Verso102023Label  matlab.ui.control.Label
        OTMVMULTLabel     matlab.ui.control.Label
        Image             matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, posicao_main)
            posicao_sobre = app.SobreUIFigure.Position;
            x = posicao_main(1)+posicao_main(3)/2-posicao_sobre(3)/2;
            y = posicao_main(2)+posicao_main(4)/2-posicao_sobre(4)/2;
            movegui(app.SobreUIFigure, [x y]);
            % Show the figure after all components are created
            app.SobreUIFigure.Visible = 'on';
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create SobreUIFigure and hide until all components are created
            app.SobreUIFigure = uifigure('Visible', 'off');
            app.SobreUIFigure.Position = [100 100 640 480];
            app.SobreUIFigure.Name = 'Sobre';
            app.SobreUIFigure.Icon = 'Icone programa.png';
            app.SobreUIFigure.Resize = 'off';

            % Create Image
            app.Image = uiimage(app.SobreUIFigure);
            app.Image.Position = [522 382 95 96];
            app.Image.ImageSource = 'Icone programa.png';

            % Create OTMVMULTLabel
            app.OTMVMULTLabel = uilabel(app.SobreUIFigure);
            app.OTMVMULTLabel.HorizontalAlignment = 'center';
            app.OTMVMULTLabel.FontSize = 20;
            app.OTMVMULTLabel.FontWeight = 'bold';
            app.OTMVMULTLabel.Position = [245 431 160 24];
            app.OTMVMULTLabel.Text = 'OptimusViaduto';

            % Create Verso102023Label
            app.Verso102023Label = uilabel(app.SobreUIFigure);
            app.Verso102023Label.HorizontalAlignment = 'center';
            app.Verso102023Label.Position = [270 410 109 22];
            app.Verso102023Label.Text = 'Versão 1.0 (2023)';

            % Create Panel
            app.Panel = uipanel(app.SobreUIFigure);
            app.Panel.BorderType = 'none';
            app.Panel.TitlePosition = 'centertop';
            app.Panel.Position = [148 350 356 49];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Panel);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];

            % Create UNIVERSIDADEFEDERALDESOCARLOSLabel
            app.UNIVERSIDADEFEDERALDESOCARLOSLabel = uilabel(app.GridLayout);
            app.UNIVERSIDADEFEDERALDESOCARLOSLabel.HorizontalAlignment = 'center';
            app.UNIVERSIDADEFEDERALDESOCARLOSLabel.Layout.Row = 1;
            app.UNIVERSIDADEFEDERALDESOCARLOSLabel.Layout.Column = 1;
            app.UNIVERSIDADEFEDERALDESOCARLOSLabel.Text = 'UNIVERSIDADE FEDERAL DE SÃO CARLOS';

            % Create CENTRODECINCIASEXATASEDETECNOLOGIALabel
            app.CENTRODECINCIASEXATASEDETECNOLOGIALabel = uilabel(app.GridLayout);
            app.CENTRODECINCIASEXATASEDETECNOLOGIALabel.HorizontalAlignment = 'center';
            app.CENTRODECINCIASEXATASEDETECNOLOGIALabel.Layout.Row = 2;
            app.CENTRODECINCIASEXATASEDETECNOLOGIALabel.Layout.Column = 1;
            app.CENTRODECINCIASEXATASEDETECNOLOGIALabel.Text = 'CENTRO DE CIÊNCIAS EXATAS E DE TECNOLOGIA';

            % Create PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel
            app.PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel = uilabel(app.GridLayout);
            app.PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel.HorizontalAlignment = 'center';
            app.PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel.Layout.Row = 3;
            app.PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel.Layout.Column = 1;
            app.PROGRAMADEPSGRADUAOEMENGENHARIACIVILLabel.Text = 'PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL';

            % Create Label
            app.Label = uilabel(app.SobreUIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontSize = 10;
            app.Label.FontAngle = 'italic';
            app.Label.Position = [31 6 586 59];
            app.Label.Text = 'Aviso: Os autores, nem a UFSCar, nem qualquer outra instituiçãorelacionada são responsáveis pelo uso ou mau uso do programa e de seus resultados. Os acima mensionados não têm nenhum dever legal ou responsabilidade para com qualquer pessoa ou companhia pelos danos causados direta ou indiretamente resultantes do uso de alguma informação ou do uso do programa aqui disponibilizado. O usuário é resposável por toda ou qualquer conclusão feita com o uso do programa. Não existe nenhum compromisso de bom funcionamento ou qualquer garantia.';

            % Create Label_2
            app.Label_2 = uilabel(app.SobreUIFigure);
            app.Label_2.HorizontalAlignment = 'center';
            app.Label_2.VerticalAlignment = 'top';
            app.Label_2.WordWrap = 'on';
            app.Label_2.FontSize = 13;
            app.Label_2.Position = [31 117 586 195];
            app.Label_2.Text = {' Neste programa é aplicada a metodologia de otimização elaborada como parte da pesquisa de doutorado do autor para projeto eficiente de viadutos compostos por longarinas I, pós-tensionadas e pré-moldadas, vigas travessas retangulares, pilares circulares e fundação profunda do tipo tubulão, considerando critérios de eficiência estrutural e sustentabilidade. A otimização implementada neste software considera custo de construção, impacto ambiental e durabilidade no projeto de viadutos. A metodologia proposta oferece um conjunto de soluções de compromisso múltiplo entre as variáveis envolvidas retornando a melhor geometria, tipo de concreto e nível de protensão.'; ''; ''; 'Desenvolvido por Eduardo Vicente Wolf Trentini, Guilherme Aris Parsekian e Túlio Nogueira Bittencourt.'; ''; 'Contato: eduardowtrentini@gmail.com'};

            % Create Image2
            app.Image2 = uiimage(app.SobreUIFigure);
            app.Image2.Position = [31 380 100 100];
            app.Image2.ImageSource = 'logo-ufscar.png';


        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = otmsobre_exported(varargin)
            
            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.SobreUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.SobreUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.SobreUIFigure)
        end
    end
end