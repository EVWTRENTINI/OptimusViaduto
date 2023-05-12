function [info,situacao,msg_erro]=dim_lajes(viaduto,info,config_draw)
% Calcula esforços e dimensiona as lajes do viaduto

situacao=true;
msg_erro='sem erro';

%% Tabela de Rusch n 27

tMxml_ee=[0 0.125 0.250 0.5 1;0.5 0.118 0.0830 0.0410 0.02;1 0.171 0.129 0.0780 0.0610;1.50 0.266 0.216 0.175 0.120;2 0.332 0.290 0.250 0.195;2.50 0.399 0.357 0.318 0.264;3 0.452 0.415 0.370 0.330;4 0.560 0.520 0.485 0.440;5 0.650 0.620 0.580 0.530;6 0.740 0.710 0.670 0.630;7 0.820 0.790 0.750 0.7;8 0.870 0.850 0.810 0.760;9 0.910 0.890 0.850 0.8;10 0.940 0.910 0.870 0.820];
tMyml_ee=[0 0.125 0.250 0.5 1;0.5 0.0970 0.0510 0.0310 0.008;1 0.149 0.0910 0.0510 0.0230;1.50 0.187 0.134 0.08 0.0380;2 0.215 0.168 0.0960 0.0640;2.50 0.248 0.198 0.137 0.0960;3 0.287 0.239 0.179 0.141;4 0.361 0.315 0.262 0.222;5 0.430 0.389 0.338 0.295;6 0.498 0.457 0.412 0.370;7 0.560 0.520 0.479 0.433;8 0.610 0.580 0.540 0.490;9 0.660 0.630 0.590 0.540;10 0.710 0.670 0.630 0.580];
tMxel_ee=[0 0.125 0.250 0.5 1;0.5 0.250 0.190 0.120 0.05;1 0.320 0.260 0.180 0.09;1.50 0.420 0.4 0.340 0.250;2 0.580 0.560 0.510 0.4;2.50 0.720 0.7 0.660 0.550;3 0.850 0.840 0.8 0.780;4 1.06 1.06 1.01 0.980;5 1.21 1.21 1.18 1.14;6 1.32 1.32 1.30 1.26;7 1.41 1.41 1.40 1.36;8 1.47 1.47 1.47 1.44;9 1.52 1.52 1.52 1.50;10 1.54 1.54 1.54 1.53];
tMxmp_ee=[0 0;0.5 0;1 0;1.50 0;2 0;2.50 0;3 0.3;4 0.8;5 1.25;6 1.65;7 2;8 2.40;9 2.75;10 3.12];
tMymp_ee=[0 0;0.5 0;1 0;1.50 0;2 0;2.50 0;3 0.05;4 0.130;5 0.210;6 0.280;7 0.330;8 0.420;9 0.480;10 0.560];
tMxep_ee=[0 0;0.5 0;1 0;1.50 0;2 0.03;2.50 0.08;3 0.2;4 0.550;5 1;6 1.40;7 2;8 2.40;9 3;10 3.50];
tMxmpl_ee=[0 0;0.5 0;1 0;1.50 0.05;2 0.1;2.50 0.270;3 0.530;4 1.11;5 1.79;6 2.90;7 4.50;8 6.30;9 8.40;10 10.55];
tMympl_ee=[0 0;0.5 0.01;1 0.01;1.50 0.03;2 0.05;2.50 0.130;3 0.240;4 0.570;5 0.830;6 1.33;7 2.03;8 2.89;9 3.82;10 4.85];
tMxepl_ee=[0 0;0.5 0.1;1 0.280;1.50 0.350;2 0.350;2.50 0.370;3 0.8;4 2.20;5 4.25;6 7.60;7 11.8;8 16.2;9 21.6;10 26.3];

%% Tabela de Rusch n 14

tMxml_ea=[0,0.125,0.25,0.5,1;0.5,0.155,0.116,0.066,0.05;1,0.24,0.19,0.148,0.096;1.5,0.362,0.313,0.254,0.189;2,0.475,0.428,0.36,0.295;2.5,0.56,0.52,0.451,0.385;3,0.63,0.6,0.53,0.466;4,0.75,0.72,0.66,0.59;5,0.84,0.82,0.76,0.69;6,0.91,0.89,0.83,0.77;7,0.97,0.96,0.89,0.83;8,1.02,1.01,0.94,0.88;9,1.06,1.05,0.98,0.92;10,1.09,1.08,1.01,0.95];
tMyml_ea=[0,0.125,0.25,0.5,1;0.5,0.116,0.061,0.024,0.013;1,0.165,0.104,0.069,0.038;1.5,0.219,0.166,0.109,0.068;2,0.271,0.213,0.148,0.1;2.5,0.317,0.262,0.194,0.142;3,0.37,0.321,0.253,0.202;4,0.467,0.421,0.353,0.304;5,0.55,0.51,0.452,0.395;6,0.63,0.59,0.53,0.477;7,0.7,0.66,0.61,0.55;8,0.75,0.71,0.67,0.61;9,0.79,0.76,0.71,0.65;10,0.82,0.79,0.74,0.69];
tMxel_ea=[0,0.125,0.25,0.5,1;0.5,0.25,0.2,0.13,0.079;1,0.382,0.34,0.255,0.19;1.5,0.48,0.45,0.39,0.34;2,0.72,0.7,0.66,0.55;2.5,0.88,0.86,0.84,0.73;3,1,0.98,0.96,0.9;4,1.2,1.18,1.16,1.12;5,1.34,1.33,1.31,1.28;6,1.45,1.44,1.42,1.38;7,1.53,1.52,1.51,1.46;8,1.58,1.57,1.56,1.51;9,1.6,1.6,1.6,1.54;10,1.61,1.61,1.61,1.55];
tMxmp_ea=[0,0;0.5,0;1,0.01;1.5,0.09;2,0.18;2.5,0.33;3,0.4;4,0.6;5,0.93;6,1.4;7,2.2;8,3.3;9,4.6;10,6];
tMymp_ea=[0,0;0.5,0;1,0;1.5,0.02;2,0.03;2.5,0.06;3,0.07;4,0.1;5,0.16;6,0.24;7,0.38;8,0.58;9,0.82;10,1.07];
tMxep_ea=[0,0;0.5,0;1,0;1.5,0.05;2,0.1;2.5,0.25;3,0.5;4,1.1;5,1.75;6,2.1;7,2.6;8,3;9,3.45;10,3.91];
tMxmpl_ea=[0,0;0.5,0;1,0;1.5,0;2,0.1;2.5,0.2;3,0.45;4,1.55;5,3.06;6,5.3;7,8.4;8,12.1;9,15.8;10,19.5];
tMympl_ea=[0,0;0.5,0;1,0.01;1.5,0.01;2,0.03;2.5,0.11;3,0.23;4,0.64;5,1.2;6,1.98;7,3.15;8,4.17;9,5.48;10,7.13];
tMxepl_ea=[0,0;0.500,0.100;1,0.200;1.50,0.400;2,0.550;2.50,0.640;3,1.40;4,3.90;5,7.03;6,11.450;7,17.4;8,24.1;9,32.1;10,39.8];


%% Esforço e dimensionamento
h_pav=viaduto.hpav;
fyd=viaduto.fyk/viaduto.gama_s;%kN/cm²
Es=viaduto.Es;%kN/cm²
alfa_e=viaduto.alfa_e;
gama_c=viaduto.gama_c;
gama_s=viaduto.gama_s;

for vao_i=1:viaduto.n_apoios-1
    %% Calculo do momento fletor
    lx=info.longarinas.vao(vao_i).longarina(2).yb-info.longarinas.vao(vao_i).longarina(1).yb;
    ly=info.longarinas.vao(vao_i).longarina(1).xe-info.longarinas.vao(vao_i).longarina(1).xb;
    b1=viaduto.vao(vao_i).longarina.b1;
    h_laje=viaduto.vao(vao_i).laje.h;
    CIV=calc_CIV(ly);
    
    
    [Mxmd_ee,Mymd_ee,Mxed_ee,Mxm_CF_max_ee,Mym_CF_max_ee,Mxe_CF_max_ee,Mxm_CF_min_ee,Mym_CF_min_ee,Mxe_CF_min_ee,Vsd_ee,VCF_max_ee,VCF_min_ee,situacao,msg_erro]=calc_esf_laje_ee(lx,ly,b1,h_pav,h_laje,CIV,tMxml_ee,tMyml_ee,tMxel_ee,tMxmp_ee,tMymp_ee,tMxep_ee,tMxmpl_ee,tMympl_ee,tMxepl_ee);
    if not(situacao); return; end
    [Mxmd_ea,Mymd_ea,Mxed_ea,Mxm_CF_max_ea,Mym_CF_max_ea,Mxe_CF_max_ea,Mxm_CF_min_ea,Mym_CF_min_ea,Mxe_CF_min_ea,Vsd_ea,VCF_max_ea,VCF_min_ea,situacao,msg_erro]=calc_esf_laje_ea(lx,ly,b1,h_pav,h_laje,CIV,tMxml_ea,tMyml_ea,tMxel_ea,tMxmp_ea,tMymp_ea,tMxep_ea,tMxmpl_ea,tMympl_ea,tMxepl_ea);
    if not(situacao); return; end
    
    %% Dimensionamento a flexão
    
    
    fck=viaduto.vao(vao_i).laje.fck/(1E6);
    c=viaduto.vao(vao_i).laje.c;
    fi_l=viaduto.lajes.fi_l;
    dxm=h_laje-c-fi_l/2;
    dym=h_laje-c-fi_l-.02;
    dxe=h_laje-c-fi_l/2;
    
    % Engastada-Engastada
    [Asxm_ee,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mxmd_ee,Mxm_CF_max_ee,Mxm_CF_min_ee,h_laje,1,dxm,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-engastada, xm.'];
        return
    end
    [Asym_ee,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mymd_ee,Mym_CF_max_ee,Mym_CF_min_ee,h_laje,1,dym,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-engastada, ym.'];
        return
    end
    [Asxe_ee,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mxed_ee,Mxe_CF_max_ee,Mxe_CF_min_ee,h_laje,1,dxe,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-engastada, xe.'];
        return
    end

    % Engastada-Apoiada
    [Asxm_ea,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mxmd_ea,Mxm_CF_max_ea,Mxm_CF_min_ea,h_laje,1,dxm,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-apoiada, xm.'];
        return
    end
    [Asym_ea,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mymd_ea,Mym_CF_max_ea,Mym_CF_min_ea,h_laje,1,dym,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-apoiada, ym.'];
        return
    end
    [Asxe_ea,situacao,msg_erro]=dim_flexao_corrige_fadiga(Mxed_ea,Mxe_CF_max_ea,Mxe_CF_min_ea,h_laje,1,dxe,fck,gama_c,alfa_e,fyd,Es);
    if not(situacao)
        msg_erro=[msg_erro '. Laje, engastada-apoiada, xe.'];
        return
    end
    

    %% Escolha da treliça
    
    % Tabela de treliças de laje
    trelicas(6)=struct('modelo','TR 30R','h',300,'b',200,'fi_s',8,'fi_d',5.0,'fi_i',8,'peso_linear',2.168,'CA',60);
    trelicas(5)=struct('modelo','TR 25R','h',250,'b',200,'fi_s',8,'fi_d',5.0,'fi_i',8,'peso_linear',2.024,'CA',60);
    trelicas(4)=struct('modelo','TR 20R','h',200,'b',200,'fi_s',7,'fi_d',5.0,'fi_i',6,'peso_linear',1.446,'CA',60);
    trelicas(3)=struct('modelo','TR 16R','h',160,'b',200,'fi_s',7,'fi_d',4.2,'fi_i',6,'peso_linear',1.168,'CA',60);
    trelicas(2)=struct('modelo','TR 12R','h',120,'b',200,'fi_s',6,'fi_d',4.2,'fi_i',6,'peso_linear',1.016,'CA',60);
    trelicas(1)=struct('modelo','TR 08M','h',080,'b',200,'fi_s',6,'fi_d',4.2,'fi_i',5,'peso_linear',0.825,'CA',60);

    % Escolher qual trelica cabe
    [~,st]=size(trelicas);%tamanho da tabela de treliças
    it=0;
    for i=st:-1:1
        h_min=trelicas(i).h/1000+2*c;
        if h_min<=h_laje
            it=i;%indice da treliça escolhida
            break
        end
    end
    if it==0
        situacao=false;
        msg_erro='Nenhuma treliça da tabela coube dentro da laje';
        return
    end

    trelica=trelicas(it);

    %% Dimensionamento da laje ao esforço cortante
    [sp_tre_ee,situacao,msg_erro]=dim_cisalhamento_laje(fck,gama_c,gama_s,dxm,Asxm_ee,trelica,Vsd_ee,VCF_max_ee,VCF_min_ee);
    if not(situacao)
        msg_erro=[msg_erro '. Engastada-engastada.'];
        return
    end
    [sp_tre_ea,situacao,msg_erro]=dim_cisalhamento_laje(fck,gama_c,gama_s,dxm,Asxm_ea,trelica,Vsd_ea,VCF_max_ea,VCF_min_ea);
    if not(situacao)
        msg_erro=[msg_erro '. Engastada-apoiada.'];
        return
    end
    espacamento_trelicas = min([sp_tre_ee sp_tre_ea]);

    %% Anota os resultados

    % Desconta o valor do aço que ja vai na treliça
    
    Asxm = max([Asxm_ee Asxm_ea]) - pi*(trelica.fi_i/10)^2/4 * 2 / espacamento_trelicas;
    Asym = max([Asym_ee Asym_ea]);
    Asxe = max([Asxe_ee Asxe_ea]); % - pi*(trelica.fi_s/10)^2/4 * 1 / espacamento_trelicas % Não desconta o aço da treliça no negativo pois não se avalia o CG
    Asye = max([max([Asxe_ee Asxe_ea])/5 .9]); % Maior entre Asxe/5 ou 0,90 cm²/m


    % Anota o resultado
    info.lajes.vao(vao_i).Asxm = max([Asxm 0]);
    info.lajes.vao(vao_i).Asym = max([Asym 0]);
    info.lajes.vao(vao_i).Asxe = max([Asxe 0]);
    info.lajes.vao(vao_i).Asye = max([Asye 0]);



    info.lajes.vao(vao_i).trelica=trelica;
    info.lajes.vao(vao_i).espacamento_trelicas = espacamento_trelicas;% em metros

end

end

function [sp_tre,situacao,msg_erro]=dim_cisalhamento_laje(fck,gama_c,gama_s,d,As,trelica,Vsd,VCF_max,VCF_min)
% Dimensionamento da laje ao esforço cortante
situacao=true;
msg_erro='sem erro';

limite_tensao_estribo = 85; %MPa

fywd = (trelica.CA)/gama_s;
if fywd > 43.5
    fywd = 43.5; % kN
end

sp_tre_max=.4;%espaçamento máximo entre treliças da laje em metros

tau_sd=Vsd/(1*d)/1000;%Tensão de cisalhamento atuante em MPa

[~,fctkinf,~] = calc_fctm(fck);

fctd=fctkinf/gama_c;

tau_rd=.25*fctd;

if As/(100*(d*100))>.02
    ro1=.02;
else
    ro1=As/(100*(d*100));
end

k=abs(1.6-d);
if k<1
    k=1;
end
tau_Vrd1=tau_rd*k*(1.2+40*ro1);%MPa



sp_tre=sp_tre_max;%espaçamento entre treliças da laje em metros

%% Verifica se precisa de estribo na laje
if tau_Vrd1<tau_sd %precisa de estribos
    %% Verifica se a diagonal de concreto comprimido resiste a solicitação

    Vrd2 = calc_Vrd2(fck,gama_c,100,d*100); % kN

    if Vrd2<Vsd
        situacao=false;
        msg_erro='Ruína das diagonais comprimidas';
        return
    end


    %% Verifica se o espaçamento minimo da treliça resolve
    %bielaapoio=45*pi/180;%rad
    bielaestri=atan(trelica.h/(trelica.b/2));%rad

    Vc0 = calc_Vc0(fctd, 100, d*100); % kN
    Vsw_1m = calc_Vsw((trelica.fi_d/10)^2/4*pi*2/(trelica.b/10),d*100,fywd,bielaestri); % kN. Vsw se o espaçamento das treliças for de 1 metro.
    Vsw_sp_tre_min = Vsw_1m/sp_tre; % kN por metro
    Vsw=Vsd-Vc0; % kN, Vsw necessário

    %% Determina espaçamento para resistir ao esforço cortante
    if Vsw>Vsw_sp_tre_min % Caso o Vsw calculado com o espaçamento maxímo não seja suficiente, então calcula o espaçamento necessário
        sp_tre=Vsw_1m/Vsw;%metros
    end


    %% Correção para fadiga
    Vsw1=VCF_max-.5*Vc0;
    if Vsw1<0
        Vsw1=0;
    end
    Vsw2=VCF_min-.5*Vc0;
    if Vsw2<0
        Vsw2=0;
    end

    sigsw1=Vsw1/(Vsw_1m/fywd*(1/sp_tre))*10;
    sigsw2=Vsw2/(Vsw_1m/fywd*(1/sp_tre))*10;

    delta_sig=sigsw1-sigsw2;
    if delta_sig>limite_tensao_estribo
        sp_tre=sp_tre/(delta_sig/limite_tensao_estribo);
    end

    %% Verifica espaçamento minimo
    if sp_tre<.07
        situacao=false;
        msg_erro='As treliças estão com espaçamento entre eixo menor que 7 cm';
        return
    end
end


end