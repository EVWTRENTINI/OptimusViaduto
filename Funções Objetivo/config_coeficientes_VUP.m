% TABELA 24a pg 152 - Modelagem da carbonatação e previsão de vida util de estruturas de comcreto em ambiente urbano

coeficientes_VUP.dados_cimento(1)  = struct('Tipo_de_cimento', 'CPI'   , 'kc', 19.80, 'kfc', 1.70, 'kad', 0.24, 'kco2', 18.0, 'kUR', 1300); 
coeficientes_VUP.dados_cimento(2)  = struct('Tipo_de_cimento', 'CPIIE' , 'kc', 22.48, 'kfc', 1.50, 'kad', 0.32, 'kco2', 15.5, 'kUR', 1300);
coeficientes_VUP.dados_cimento(3)  = struct('Tipo_de_cimento', 'CPIIF' , 'kc', 21.68, 'kfc', 1.50, 'kad', 0.24, 'kco2', 18.0, 'kUR', 1100);
coeficientes_VUP.dados_cimento(4)  = struct('Tipo_de_cimento', 'CPIIZ' , 'kc', 23.66, 'kfc', 1.50, 'kad', 0.32, 'kco2', 15.5, 'kUR', 1300);
coeficientes_VUP.dados_cimento(5)  = struct('Tipo_de_cimento', 'CPIII' , 'kc', 30.50, 'kfc', 1.70, 'kad', 0.32, 'kco2', 15.5, 'kUR', 1300);
coeficientes_VUP.dados_cimento(6)  = struct('Tipo_de_cimento', 'CPIV'  , 'kc', 33.27, 'kfc', 1.70, 'kad', 0.32, 'kco2', 15.5, 'kUR', 1000);
coeficientes_VUP.dados_cimento(7)  = struct('Tipo_de_cimento', 'CPVARI', 'kc', 19.80, 'kfc', 1.70, 'kad', 0.24, 'kco2', 18.0, 'kUR', 1300);
coeficientes_VUP.ad_concreto(1)  = struct('fck', 15, 'ad',  0);
coeficientes_VUP.ad_concreto(2)  = struct('fck', 50, 'ad',  0);
coeficientes_VUP.ad_concreto(3)  = struct('fck', 60, 'ad', 10);
coeficientes_VUP.ad_concreto(4)  = struct('fck', 65, 'ad', 10);
coeficientes_VUP.ad_concreto(5)  = struct('fck', 70, 'ad', 10);
coeficientes_VUP.ad_concreto(6)  = struct('fck', 80, 'ad', 10);
coeficientes_VUP.kce = 1; % 1.3, 1 ou 0,65
coeficientes_VUP.cv_fc = .15;
coeficientes_VUP.cv_c = .15;
coeficientes_VUP.CO2m = .055;
coeficientes_VUP.cv_CO2 = .1;
coeficientes_VUP.URm = 60;
coeficientes_VUP.cv_UR = .15;
coeficientes_VUP.numero_de_analises = 8000;
coeficientes_VUP.probabilidade_de_falha = .067;
