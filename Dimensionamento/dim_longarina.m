function [info,situacao,msg_erro] = dim_longarina(ENVLONGA,ENVLONGACR,ENVLONGACF,ENVLONGACQP,MFLECHA,ENVAPAPOIO,vao_i,long_i,viaduto,secaoll,info,xb,tot_ponto,LC_cd_PP,config_draw)
%Dimensiona as longarinas com 2 etapas de concretagem
%   Não funciona com longarinas depois do eixo de simetria

info.longarinas.vao(vao_i).longarina(long_i).recalcular_protensao = false;
info.longarinas.vao(vao_i).longarina(long_i).adicionar_cordoalhas = 0;
info.longarinas.vao(vao_i).longarina(long_i).remover_cordoalhas = 0;

Asl=0;
situacao=true;
msg_erro='sem erro';

Nsd=0;%kN

mlong=info.longarinas.vao(vao_i).longarina(long_i).membros;

W=viaduto.W;
fi_t=viaduto.longa_fi_tran;
fi_l_min=viaduto.longa_fi_long_min;
fi_l_max=viaduto.longa_fi_long_max;

c=viaduto.vao(vao_i).longarina.c;
b1=viaduto.vao(vao_i).longarina.b1;
b2=viaduto.vao(vao_i).longarina.b2;
b3=viaduto.vao(vao_i).longarina.b3;
enr=viaduto.vao(vao_i).longarina.enr;
benr=viaduto.vao(vao_i).longarina.benr;
h1=viaduto.vao(vao_i).longarina.h1;
h2=viaduto.vao(vao_i).longarina.h2;
h3=viaduto.vao(vao_i).longarina.h3;
h4=viaduto.vao(vao_i).longarina.h4;
h5=viaduto.vao(vao_i).longarina.h5;




hlj=viaduto.vao(vao_i).laje.h;
fck=viaduto.vao(vao_i).longarina.fck/1E6;%MPa;
gama_c=viaduto.gama_c;
n_longa=viaduto.vao(vao_i).n_longarinas;
l=xb(tot_ponto(mlong),mlong);

t=viaduto.longarinas.delta_t_ef;%dias (data da protensão)
DMLG=viaduto.DMLG;%(Data do içamento das longarinas)
DCLJ=viaduto.DCLJ;%data da concretagem da laje em dias (para o calculo da def da primeira etapa e instabilidade lateral da longarina)
alfa_e=viaduto.alfa_e;
s_cim=viaduto.longarinas.s;
ktap=info.aparelhos_de_apoio.vao(vao_i).ktap;%kNm/rad
hap=viaduto.vao(vao_i).hap;
cdl=viaduto.cdl;
ex_ap=viaduto.ex_ap;
ex_lg=viaduto.ex_lg;
mT_lg_livre=viaduto.mT_lg_livre;
mT_lg_travada=viaduto.mT_lg_travada;
fs_r=viaduto.fs_r;%Fator de minoração da resistencia ao tombamento FS=pp_crit/(pp_long_k*gama_gd_esp)
fs_pcrit=viaduto.fs_pcrit;%Fator de minoração da carga critica FS=w_crit/((pp_long_k+pp_laje_k)*gama_gd_esp)

V90td=viaduto.V90_tabuleiro_descarregado;%Força do vento no tabueliro descarregado em kN/m²



switch long_i
    case 1
        blj=(W-b1)/(n_longa-1)/2+b1/2;%Largura da laje sobre a longarina(m)
    case n_longa
        blj=(W-b1)/(n_longa-1)/2+b1/2;
    otherwise
        blj=(W-b1)/(n_longa-1);
end
blj_colab=blj-info.longarinas.vao(vao_i).longarina(long_i).laje_sup;


% Propriedades da seção da longarina-laje
secaoll(:,1)=[];
All=info.longarinas.vao(vao_i).longarina(long_i).A;
Iyll=info.longarinas.vao(vao_i).longarina(long_i).Iy;
ull=info.longarinas.vao(vao_i).longarina(long_i).u;

% Propriedades da longarina-laje enrijecida
secaollenr=info.longarinas.vao(vao_i).longarina(long_i).secao_enr;
Allenr=info.longarinas.vao(vao_i).longarina(long_i).Aenr;
Iyllenr=info.longarinas.vao(vao_i).longarina(long_i).Ienr;
ullenr=info.longarinas.vao(vao_i).longarina(long_i).uenr;


% Propriedades da seção da longarina pré-moldada
[secaol,Al,Iyl,ZCGl,secaolenr,Alenr,Iylenr,ZCGlenr] = secao_long(viaduto,vao_i);%seção da longarina pré-moldada
info.longarinas.vao(vao_i).longarina(long_i).Apre=Al;%m²
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).Apre=Al;%m²
info.longarinas.vao(vao_i).longarina(long_i).Apreenr=Alenr;%m²
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).Apreenr=Alenr;%m²

% Checa a espessura minima considerando combrimento e diametro das barras
% % % esp_min=min([b1 b2 b3 benr]);
% % % offsetmaximo=c+fi_t+fi_l_max;
% % % if esp_min/2<=offsetmaximo
% % %     situacao=false;
% % %     msg_erro=['Menor espessura da seção transversal é menor que a minima de ' num2str(offsetmaximo*2*100) ' cm'];
% % % end
% % % if not(situacao); return; end

% Pripriedades dos cabos
cabos=info.longarinas.vao(vao_i).longarina(long_i).cabos;

ndc=viaduto.disc_cabos;%numero de discretização do traçado do cabo
amp=viaduto.vao(vao_i).amp; %altura máxima do cabo de protensão

dcabo=viaduto.dcabo;%diametro do cabo em metros
xcabo=cabos(1).x-cabos(1).x(2);
teta_h=info.longarinas.vao(vao_i).longarina(long_i).caboresul_teta_h;%angulo com a horizontal do cabo resultante

aal=info.longarinas.vao(vao_i).longarina(long_i).aal;

aall=aal;
aall.y(:)=aall.y(:)+(min(secaoll(:,2))-min(secaol(:,2)));
aall_ime=aall;

centro=ceil((ndc+3)/2);
aall.Epp(1:aal.n)=info.longarinas.vao(vao_i).longarina(long_i).Epp(centro)*1000;
aall_ime.Epp(1:aal.n)=info.longarinas.vao(vao_i).longarina(long_i).Eppime(centro)*1000;




% Esforços necessarios para o calculo das percas e para o dimensionamento
[Mg0k,R]=calc_Mg0(cabos(1).x,Al,vao_i,long_i,viaduto,info);%N.m e N                   peso proprio da longarina pré-moldada e reação de apoio

Mg0k=Mg0k/1000;%kN.m

l0f=cabos(1).x(viaduto.disc_cabos+3)-2*cabos(1).x(2);%m
R=R/1000;%kN
q_lg_k=R*2/l0f;%kN/m - Carga distribuida equivalente ao peso próprio da longarina de cálculo 
q_lj_k=blj*hlj*25;%kN/m - Carga distribuida equivalente ao peso próprio da laje de cálculo 

%Mg= calc_Mg(cabos(1).x,vao_i,long_i,LC_cd_PP,viaduto,info)/1000;%kN.m                 peso proprio total agindo na seção composta
Mg2ek=double(Mg0k(centro))+(25*hlj*blj)*l^2/8;%kN.m;     peso proprio no ato da concretagem

% para o cálculo da flecha
[Mg2e]=transpose(calc_Mg2e(transpose(xb(1:tot_ponto(mlong),mlong)),vao_i,long_i,viaduto,info,hlj,blj))/1000; % kN.m;


Mcf=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),ENVLONGACF.MAX.My,cabos(1).x-cabos(1).x(2));
Mcf(1,1)=0;
Mcf(1,2)=0;
Mcf(1,end)=0;
Mcf(1,end-1)=0;
Mcf=Mcf/1000;%kN.m

Mcr=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),ENVLONGACR.MAX.My,cabos(1).x-cabos(1).x(2));
Mcr(1,1)=0;
Mcr(1,2)=0;
Mcr(1,end)=0;
Mcr(1,end-1)=0;
Mcr=Mcr/1000;%kN.m

Mcqp=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),ENVLONGACQP.MAX.My,cabos(1).x-cabos(1).x(2));
Mcqp(1,1)=0;
Mcqp(1,2)=0;
Mcqp(1,end)=0;
Mcqp(1,end-1)=0;
Mcqp=Mcqp/1000;%kN.m



%% Verificação das tensões no ato e em serviço



tfs_ato=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra superior no ato da protensão
tfi_ato=zeros(1,viaduto.disc_cabos+3);% Tensão na inferior superior no ato da protensão
tfs_cf=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra superior na cominação frequente
tfi_cf=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra inferior na cominação frequente
tfs_cr=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra superior na cominação rara
tfi_cr=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra inferior na cominação rara
tfs_cqp=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra superior na cominação quase permanente
tfi_cqp=zeros(1,viaduto.disc_cabos+3);% Tensão na fibra inferior na cominação quase permanente

Pime=info.longarinas.vao(vao_i).longarina(long_i).Pime;%kN
Pinf=info.longarinas.vao(vao_i).longarina(long_i).Pinf;%kN
epl=info.longarinas.vao(vao_i).longarina(long_i).epl;%m
ep=info.longarinas.vao(vao_i).longarina(long_i).ep;%m

fck_t = calc_fct(fck,s_cim,t);
[fctm_t,~,~] = calc_fctm(fck_t);
[~,fctkinf,~] = calc_fctm(fck);

limite_tensao_compressao_combinacao_frequente =-fck * .6;%limite da tensão de copressão na combinação frequente
limite_tensao_tracao_ato = fctm_t * 1.2;
limite_tensao_compressao_ato = -fck_t * .7;

config_Mc

casos_gama_p = [1 1.1];
n_casos_gama_p = length(casos_gama_p);

adicionar_cordoalhas_ato = zeros(1, n_casos_gama_p);
remover_cordoalhas_ato = zeros(1, n_casos_gama_p);
corrigir_cordoalhas_ato = zeros(5,viaduto.disc_cabos+3);

for i = 1:n_casos_gama_p
    gama_p = casos_gama_p(i);
    for s=1:viaduto.disc_cabos+3
        %+(ZCGl-ZCGlenr)
        if or(xcabo(s)<l*enr*1.01,xcabo(s)>l*(1-enr*1.01))
            tfs_ato(s)=-(Mg0k(s)/1000+(gama_p*Pime(s)/1000*(epl(s)+(ZCGl-ZCGlenr))))*max(secaolenr(:,2) )/Iylenr+ (-gama_p*Pime(s)/1000)/Alenr;%MPa
            tfi_ato(s)=-(Mg0k(s)/1000+(gama_p*Pime(s)/1000*(epl(s)+(ZCGl-ZCGlenr))))*min(secaolenr(:,2) )/Iylenr+ (-gama_p*Pime(s)/1000)/Alenr;%MPa
            tfs_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
            tfi_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
            tensao_por_cabo_ime_s(s) = (-((gama_p*Pime(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pime(s)/1000)/Allenr)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_inf_s(s) = (-((gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_ime_i(s) = (-((gama_p*Pime(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pime(s)/1000)/Allenr)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_inf_i(s) = (-((gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr)/viaduto.vao(vao_i).ntcord; % MPa
        else
            tfs_ato(s)=-(Mg0k(s)/1000+(gama_p*Pime(s)/1000*epl(s)))*max(secaol(:,2) )/Iyl+ (-gama_p*Pime(s)/1000)/Al;%MPa
            tfi_ato(s)=-(Mg0k(s)/1000+(gama_p*Pime(s)/1000*epl(s)))*min(secaol(:,2) )/Iyl+ (-gama_p*Pime(s)/1000)/Al;%MPa
            tfs_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
            tfi_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
            tensao_por_cabo_ime_s(s) = (-((gama_p*Pime(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pime(s)/1000)/All)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_inf_s(s) = (-((gama_p*Pinf(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_ime_i(s) = (-((gama_p*Pime(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pime(s)/1000)/All)/viaduto.vao(vao_i).ntcord; % MPa
            tensao_por_cabo_inf_i(s) = (-((gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All)/viaduto.vao(vao_i).ntcord; % MPa
        end
    end
  
% %     % Desenho
% %     figure(1321)
% %     clf
% %     hold on
% %     plot(cabos(1).x,tfs_ato,'DisplayName','tfs ato')
% %     plot(cabos(1).x,tfi_ato,'DisplayName','tfi ato')
% %     plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[limite_tensao_tracao_ato limite_tensao_tracao_ato],'r','DisplayName','Limite tração')
% %     plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[limite_tensao_compressao_ato   limite_tensao_compressao_ato],'r','DisplayName','Limite compressão')
% %     legend
% %     hold off
% %     
% %     %Limite de compressão na combinação frequente (60% ou 50%)
% %     figure(1322)
% %     clf
% %     hold on
% %     plot(cabos(1).x,tfs_cf,'DisplayName','tfs cf')
% %     plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[limite_tensao_compressao_combinacao_frequente   limite_tensao_compressao_combinacao_frequente],'r','DisplayName','Limite compressão')
% %     hold off
% %     legend
% %     % FIM desenho
    

    
    % Segurança ato da protensão

    if sum(tfs_ato>limite_tensao_tracao_ato)>0
        situacao=false;
        msg_erro=['Insegurança no ato da protensão. Tensão na fibra superior maior que ' num2str(limite_tensao_tracao_ato) ' MPa'];
        tensao_faltante = limite_tensao_tracao_ato-tfs_ato;
        corrigir_cordoalhas_ato(1,tensao_faltante<0) = tensao_faltante(tensao_faltante<0)./tensao_por_cabo_ime_s(tensao_faltante<0);
    end
    if sum(tfs_ato<limite_tensao_compressao_ato)>0
        situacao=false;
        msg_erro=['Insegurança no ato da protensão. Tensão na fibra superior menor que ' num2str(limite_tensao_compressao_ato) ' MPa'];
        tensao_faltante = limite_tensao_compressao_ato-tfs_ato;
        corrigir_cordoalhas_ato(2,tensao_faltante>0) = tensao_faltante(tensao_faltante>0)./tensao_por_cabo_ime_s(tensao_faltante>0);
    end
    if and(tfi_ato(1)>limite_tensao_tracao_ato,tfi_ato(viaduto.disc_cabos+3)>limite_tensao_tracao_ato)>0%Checagem só proximo as ancoragems pra não impedir dimensionamento com pouca protensão
        situacao=false;
        msg_erro=['Insegurança no ato da protensão. Tensão na fibra inferior, proximo as ancoragens, maior que ' num2str(limite_tensao_tracao_ato) ' MPa'];
        tensao_faltante = zeros(1,viaduto.disc_cabos+3);
        tensao_faltante(1) = limite_tensao_tracao_ato-tfi_ato(1);
        tensao_faltante(viaduto.disc_cabos+3) = limite_tensao_tracao_ato-tfi_ato(viaduto.disc_cabos+3);
        corrigir_cordoalhas_ato(3,tensao_faltante<0) = tensao_faltante(tensao_faltante<0)./tensao_por_cabo_ime_i(tensao_faltante<0);
    end
    if sum(tfi_ato<limite_tensao_compressao_ato)>0
        situacao=false;
        msg_erro=['Insegurança no ato da protensão. Tensão na fibra inferior menor que ' num2str(limite_tensao_compressao_ato) ' MPa'];
        tensao_faltante = limite_tensao_compressao_ato-tfi_ato;
        corrigir_cordoalhas_ato(4,tensao_faltante>0) = tensao_faltante(tensao_faltante>0)./tensao_por_cabo_ime_i(tensao_faltante>0);      
    end
    
    if sum(tfs_cf<limite_tensao_compressao_combinacao_frequente)>0% O livro Ponte de concreto do Mounir recomenda 50% na pagina 317.
        situacao=false;
        msg_erro=['Tensão na fibra superior na combinação frequente maior que ' num2str(limite_tensao_compressao_combinacao_frequente) ' MPa'];
        tensao_faltante = limite_tensao_compressao_combinacao_frequente-tfs_cf;
        corrigir_cordoalhas_ato(5,tensao_faltante>0) = tensao_faltante(tensao_faltante>0)./tensao_por_cabo_ime_s(tensao_faltante>0);  
    end

    adicionar_cordoalhas_ato(i) = ceil(max(max([corrigir_cordoalhas_ato; zeros(1,viaduto.disc_cabos+3)])));

    remover_cordoalhas_ato(i) = ceil(-min(min([corrigir_cordoalhas_ato; zeros(1,viaduto.disc_cabos+3)])));

end

adicionar_cordoalhas_ato = max(adicionar_cordoalhas_ato);
remover_cordoalhas_ato = max(remover_cordoalhas_ato);

recalcular_protensao_ato = false;
if or(adicionar_cordoalhas_ato > 0, remover_cordoalhas_ato > 0)
    recalcular_protensao_ato = true;
end


if and(adicionar_cordoalhas_ato > 0, remover_cordoalhas_ato > 0)
    situacao=false;
    msg_erro='Não existe solução para o número de cordoalhas para atender a segurança no ato da protensão';
    return
end



% Verificação do nível de protensão
gama_p=1;
for s=1:viaduto.disc_cabos+3
    %+(ZCGl-ZCGlenr)
    if or(xcabo(s)<l*enr*1.01,xcabo(s)>l*(1-enr*1.01))
        tfs_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tfi_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tfs_cr(s)= -(Mcr(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tfi_cr(s)= -(Mcr(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tfs_cqp(s)= -(Mcqp(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*max(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tfi_cqp(s)= -(Mcqp(s)/1000+(gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr;%MPa
        tensao_por_cabo_inf_nivel(s) = (-((gama_p*Pinf(s)/1000*(ep(s)-(min(secaoll(:,2))-min(secaollenr(:,2))))))*min(secaollenr(:,2))/Iyllenr+(-gama_p*Pinf(s)/1000)/Allenr)/viaduto.vao(vao_i).ntcord; % MPa
    else
        tfs_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tfi_cf(s)= -(Mcf(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tfs_cr(s)= -(Mcr(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tfi_cr(s)= -(Mcr(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tfs_cqp(s)= -(Mcqp(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*max(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tfi_cqp(s)= -(Mcqp(s)/1000+(gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All;%MPa
        tensao_por_cabo_inf_nivel(s) = (-((gama_p*Pinf(s)/1000*ep(s) ))*min(secaoll(:,2))/Iyll+(-gama_p*Pinf(s)/1000)/All)/viaduto.vao(vao_i).ntcord; % MPa
    end
end




% % Desenho
% % Protensão Completa
% figure(1323)
% clf
% hold on
% plot(cabos(1).x,tfs_cr,'DisplayName','tfs cr')
% plot(cabos(1).x,tfi_cr,'DisplayName','tfi cr')
% plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[fctkinf*1.2   fctkinf*1.2],'r','DisplayName','Tensão limite ELS-F')
% hold off
% legend
% 
% figure(1324)
% clf
% hold on
% plot(cabos(1).x,tfs_cf,'DisplayName','tfs cf')
% plot(cabos(1).x,tfi_cf,'DisplayName','tfi cf')
% plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[0   0],'r','DisplayName','Tensão limite ELS-D')
% hold off
% legend
% 
% % Protensão Limitada
% figure(1325)
% clf
% hold on
% plot(cabos(1).x,tfs_cf,'DisplayName','tfs cf')
% plot(cabos(1).x,tfi_cf,'DisplayName','tfi cf')
% plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[fctkinf*1.2   fctkinf*1.2],'r','DisplayName','Tensão limite ELS-F')
% hold off
% legend
% 
% figure(1326)
% clf
% hold on
% plot(cabos(1).x,tfs_cqp,'DisplayName','tfs cqp')
% plot(cabos(1).x,tfi_cqp,'DisplayName','tfi cqp')
% plot([cabos(1).x(1) cabos(1).x(viaduto.disc_cabos+3)],[0   0],'r','DisplayName','Tensão limite ELS-D')
% hold off
% legend




recalcular_protensao_nivel = false;
adicionar_cordoalhas_nivel = 0;
remover_cordoalhas_nivel = 0;



switch viaduto.nivel_minimo_de_protensao
    case 2
        protensao_limitada = and(and(all(tfs_cf < fctkinf*1.2), all(tfi_cf < fctkinf*1.2)), and(all(tfs_cqp < 0), all(tfi_cqp < 0)));

        adicionar_cordoalhas_nivel = max(max([((fctkinf*1.2 - tfi_cf)./tensao_por_cabo_inf_nivel);...
            ((0 - tfi_cqp)./tensao_por_cabo_inf_nivel)]));

        remover_cordoalhas_nivel = max(max([((fctkinf*1.2 - tfs_cf)./tensao_por_cabo_inf_nivel);...
            ((0 - tfs_cqp)./tensao_por_cabo_inf_nivel)]));

        if not(protensao_limitada)
            situacao=false;
            msg_erro='Não atinge protensão litada';
            recalcular_protensao_nivel = true;
            adicionar_cordoalhas_nivel = ceil(max([(adicionar_cordoalhas_nivel)*1.1 0]));
            remover_cordoalhas_nivel = ceil(max([(remover_cordoalhas_nivel)*1.1 0]));
        end
    case 3
        protensao_completa = and(and(all(tfs_cr < fctkinf*1.2), all(tfi_cr < fctkinf*1.2)), and(all(tfs_cf < 0), all(tfi_cf < 0)));

        adicionar_cordoalhas_nivel = max(max([((fctkinf*1.2 - tfi_cr)./tensao_por_cabo_inf_nivel);...
            ((0 - tfi_cf)./tensao_por_cabo_inf_nivel)]));

        remover_cordoalhas_nivel = max(max([((fctkinf*1.2 - tfs_cr)./tensao_por_cabo_inf_nivel);...
            ((0 - tfs_cf)./tensao_por_cabo_inf_nivel)]));

        if not(protensao_completa)
            situacao=false;
            msg_erro='Não atinge protensão completa';
            recalcular_protensao_nivel = true;
            adicionar_cordoalhas_nivel = ceil(max([(adicionar_cordoalhas_nivel)*1.1 0]));
            remover_cordoalhas_nivel = ceil(max([(remover_cordoalhas_nivel)*1.1 0]));
        end
end

if and(adicionar_cordoalhas_nivel > 0, remover_cordoalhas_nivel > 0)
    situacao=false;
    msg_erro='Não existe solução para o número de cordoalhas para atender o nível de protensão';
    return
end

%% Prepara correção tanto do ato quanto do nível de protensão
if or(recalcular_protensao_ato == true, recalcular_protensao_nivel == true)
    adicionar_cordoalhas = max([adicionar_cordoalhas_ato adicionar_cordoalhas_nivel]);
    remover_cordoalhas = max([remover_cordoalhas_ato remover_cordoalhas_nivel]);
    if and(adicionar_cordoalhas > 0, remover_cordoalhas > 0)
        situacao=false;
        msg_erro='Não existe solução para o número de cordoalhas para atender a segurança no ato e simultaneamente atender o nível de protensão';
        return
    end

    info.longarinas.vao(vao_i).longarina(long_i).recalcular_protensao = true;
    info.longarinas.vao(vao_i).longarina(long_i).adicionar_cordoalhas = adicionar_cordoalhas;
    info.longarinas.vao(vao_i).longarina(long_i).remover_cordoalhas = remover_cordoalhas;
end

if situacao == false
    return
end


%% Limite de flecha

[situacao, msg_erro, info] = confere_flecha_longarina(xb, tot_ponto, mlong, xcabo, epl, Pime, Mg2e, MFLECHA, t, DMLG, viaduto, fck, s_cim, alfa_e, Iyl, Iyll, info, vao_i, long_i,  psi_2);
if not(situacao); return; end
%% Confere estabilidade lateral da longarina

if viaduto.analise_nao_linear_de_estabilidade_lateral==false % Caso seja optado pela análise linear
    % Confere se atente o limite de esbeltez para analise não linear da NBR 7187:2021
    
    if l0f*h1^(1/3)/(b1^(4/3))>50
        situacao=false;
        msg_erro='Longarina muito esbelta para análise linear';
        return
    end
    
else % Caso seja optado pela análise não linear
    % Analise não linear
    
    gama_gc=[gama_gd_esp gama_gf_esp];
    gama_pc=[.9 1.1];%Coeficiente de ponderação da protensão da combinação especiais ou de construção
    
    fs_c=1;% Fator de segurança sobre as tensões no concreto
    
    
    [situacao,msg_erro] = confere_estabilidade_lateral(l0f,secaol,epl(centro),Pime(centro),gama_pc,gama_gc,Nsd,Mg0k(centro),Mg2ek,q_lg_k,q_lj_k,fck,s_cim,DMLG,DCLJ,alfa_e,fs_c,fs_r,fs_pcrit,hap,ktap,cdl,ex_ap,ex_lg,mT_lg_livre,mT_lg_travada,b1,b2,b3,h1,h2,h5,config_draw);
    if not(situacao); return; end
    
end

%% Verificação do aparelho de apoio
% Cálculo da rotação do aparelho de apoio por conta da protensão

[rbp, rep] = avalia_rotacao_apoio_protensao(...
    ep(2:viaduto.disc_cabos+2),... excentricidade da protensão em metros
    Pinf(2:viaduto.disc_cabos+2),... força de protensão em kN por nó discretizado
    cabos(1).x(2:viaduto.disc_cabos+2)-cabos(1).x(2),... discretização em x em metros
    calc_Ecs(fck*1E6,viaduto.alfa_e)/(1E3),... módulo de elasticidade em kN/m²
    Iyll); % Inercia em y em m^4


% Verificação do aparelho de apoio

[situacao,msg_erro] = avalia_aparelho_de_apoio_longarina(info, vao_i, long_i, viaduto, rbp, rep, ENVAPAPOIO);
if not(situacao); return; end

%% Dimensionamento da armadura de flexão longitudinal


As_min=Al*.15/100;%minima
As_max=Al*4/100;%máxima
%Armadura passiva superior do conjunto longarina laje
%atribuindo armadura mínima como armadura superior
[ap_supll,situacao,msg_erro] = aloja_faixas_armadura_superior(secaoll,As_min,As_min,As_max,hlj,c,viaduto,config_draw);
if not(situacao); return; end


%Momento solicitante na longarina
Msd=ENVLONGA.MAX.My(ceil(length(ENVLONGA.MAX.My)/2))/1000;%kN.m
Msd=double(Msd);%kN




%Determina a área de aço de flexão considerando duas etapa de concretagem
[Asl,situacao,msg_erro] =flexao_As2e(secaol,secaoll,fck,s_cim,DCLJ,gama_c,Msd,Nsd,Mg2ek*gama_gd,aall,aall_ime,ap_supll,c,amp,hlj,blj_colab,As_min,As_max,viaduto,config_draw);%m²
if not(situacao); return; end

info.longarinas.vao(vao_i).longarina(long_i).Asl=Asl*10^4;%cm²
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).Asl=Asl*10^4;%cm²



%% Dimensionamento da armadura transversal resistente a esforço cortante e a torsor
if Asl<=As_min
    fi_l=fi_l_min;
elseif Asl>=As_max
    fi_l=fi_l_max;
else
    fi_l=fi_l_min+(fi_l_max-fi_l_min)/(As_max-As_min)*(Asl-As_min);
end


lb=info.longarinas.vao(vao_i).longarina(long_i).lb;
disc_cor_tor=viaduto.vao(vao_i).disc_cor_tor;
[~,sdct]=size(disc_cor_tor);

sx=disc_cor_tor(1:ceil(sdct/2)).*lb;
sxi=disc_cor_tor.*lb;%sx inteiro
[~,ss]=size(sx);

tp=tot_ponto(mlong);
sVmaxxb=zeros(1,tp);
sVminxb=zeros(1,tp);
sVmaxCFxb=zeros(1,tp);
sVminCFxb=zeros(1,tp);
sTmaxxb=zeros(1,tp);
sTminxb=zeros(1,tp);
sTmaxCFxb=zeros(1,tp);
sTminCFxb=zeros(1,tp);

for i=1:tp
    % A segunda parte é para considerar a analise feita pela esquerda ou
    % pela direita
    sVmaxxb(i)=max([ENVLONGA.MAX.Vz(i) -ENVLONGA.MIN.Vz(tp-(i-1))]);
    sVminxb(i)=min([ENVLONGA.MIN.Vz(i) -ENVLONGA.MAX.Vz(tp-(i-1))]);
    
    sVmaxCFxb(i)=max([ENVLONGACF.MAX.Vz(i) -ENVLONGACF.MIN.Vz(tp-(i-1))]);
    sVminCFxb(i)=min([ENVLONGACF.MIN.Vz(i) -ENVLONGACF.MAX.Vz(tp-(i-1))]);
    
    sTmaxxb(i)=max([ENVLONGA.MAX.Tx(i) -ENVLONGA.MIN.Tx(tp-(i-1))]);
    sTminxb(i)=min([ENVLONGA.MIN.Tx(i) -ENVLONGA.MAX.Tx(tp-(i-1))]);
    
    sTmaxCFxb(i)=max([ENVLONGACF.MAX.Tx(i) -ENVLONGACF.MIN.Tx(tp-(i-1))]);
    sTminCFxb(i)=min([ENVLONGACF.MIN.Tx(i) -ENVLONGACF.MAX.Tx(tp-(i-1))]);
end

sVmax=  interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sVmaxxb,sx)/1000;%kN
sVmin=  interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sVminxb,sx)/1000;%kN

sVmaxCF=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sVmaxCFxb,sx)/1000;%kN 
sVminCF=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sVminCFxb,sx)/1000;%kN

sTmax=  interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sTmaxxb,sx)/1000;%kN
sTmin=  interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sTminxb,sx)/1000;%kN

sTmaxCF=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sTmaxCFxb,sx)/1000;%kN 
sTminCF=interp1(transpose(xb(1:tot_ponto(mlong),mlong)),sTminCFxb,sx)/1000;%kN






Mdmax=   interp1(transpose(xb(1:tot_ponto(mlong),mlong)),ENVLONGA.MAX.My,sx)/1000; % kN.m % Momento maximo que causa o cortante maximo (Aproximado mas n da diferença)

Av=zeros(1,ss);
Iv=zeros(1,ss);
yminv=zeros(1,ss);
ymaxv=zeros(1,ss);
bwef=zeros(1,ss);
Asobreu=zeros(1,ss);
he=zeros(1,ss);
Ae=zeros(1,ss);
ue=zeros(1,ss);
Ast=zeros(1,ss);
Aslt=zeros(1,ss);
d=zeros(2,ss);

Pinfv=zeros(2,ss);
epv=zeros(2,ss);
teta_hv=zeros(2,ss);

M0=zeros(2,ss);
Vrd2=zeros(2,ss);
Trd2=zeros(2,ss);
combVT=zeros(2,ss);
beta1=zeros(2,ss);
Vc0=zeros(2,ss);
Vc=zeros(2,ss);
Vsw=zeros(2,ss);
Asw_s=zeros(2,ss);
As90_s=zeros(2,ss);

Vsw1=zeros(2,ss);
Vsw2=zeros(2,ss);
sigsw1=zeros(2,ss);
sigsw2=zeros(2,ss);
deltasigsw=zeros(2,ss);
Aswcor=zeros(2,ss);

deltasigswT=zeros(2,ss);
As90cor=zeros(2,ss);

Astramo=zeros(2,ss);

Astmin=zeros(1,ss);




teta_hn=zeros(1,ndc+3);%teta horizontal nos nós o teta_h é nos trechos entre nós
teta_hn(1)=teta_h(1);
teta_hn(end)=teta_h(end);
for i=2:ndc+2
    teta_hn(i)=teta_h(i-1)+(teta_h(i)-teta_h(i-1))/(xcabo(i+1)-xcabo(i-1))*(xcabo(i)-xcabo(i-1));
end

Pinfv(1,:)=interp1(xcabo,Pinf,sxi(1:ceil(sdct/2)));
Pinfv(2,:)=interp1(xcabo,Pinf,sxi(ceil(sdct/2)+1:sdct));
Pinfv(2,:)=fliplr(Pinfv(2,:));

epv(1,:)=interp1(xcabo,ep,sxi(1:ceil(sdct/2)));
epv(2,:)=interp1(xcabo,ep,sxi(ceil(sdct/2)+1:sdct));
epv(2,:)=fliplr(epv(2,:));

teta_hv(1,:)=interp1(xcabo,teta_hn,sxi(1:ceil(sdct/2)));
teta_hv(2,:)=interp1(xcabo,teta_hn,sxi(ceil(sdct/2)+1:sdct));
teta_hv(2,:)=-fliplr(teta_hv(2,:));

[fctm,fctkinf,~] = calc_fctm(fck);
fctd=fctkinf/gama_c;

c1=c+fi_t+fi_l/2;
for s=1:ss
    he(s)=2*c1;
    if sx(s)<enr*lb*0.99
        Av(s)=Allenr;
        Iv(s)=Iyllenr;
        epv(:,s)=epv(:,s)-(min(secaoll(:,2))-min(secaollenr(:,2)));
        ymaxv(s)=max(secaollenr(:,2));
        yminv(s)=min(secaollenr(:,2));
        
        bwef(s)=benr-dcabo/2;
        Asobreu(s)=Allenr/ullenr;
        if he(s)>Asobreu(s)
            he(s)=Asobreu(s);
            if Asobreu(s)>(bwef(s)+dcabo/2-2*c1)
                he(s)=(bwef(s)+dcabo/2);
            end
        end
        [secaooffset.x,secaooffset.y]=offsetCurve(transpose(secaollenr(1:end-1,1)),transpose(secaollenr(1:end-1,2)), c1);
        secaooffset.y(1)=secaooffset.y(1)-c1;
        secaooffset.y(end)=secaooffset.y(end)-c1;
        geom=polygeom(secaooffset.x,secaooffset.y);
        Ae(s)=geom(1);
        ue(s)=geom(4);
        
        d(:,s)=(ymaxv(s)-epv(:,s));
    else
        Av(s)=All;
        Iv(s)=Iyll;
        ymaxv(s)=max(secaoll(:,2));
        yminv(s)=min(secaoll(:,2));
        
        bwef(s)=b2-dcabo/2;
        Asobreu(s)=All/ull;
        if he(s)>Asobreu(s)
            he(s)=Asobreu(s);
            if Asobreu(s)>(bwef(s)+dcabo/2-2*c1)
                he(s)=(bwef(s)+dcabo/2);
            end
        end
        [secaooffset.x,secaooffset.y]=offsetCurve(transpose(secaoll(1:end-1,1)),transpose(secaoll(1:end-1,2)), c1);
        secaooffset.y(1)=secaooffset.y(1)-c1;
        secaooffset.y(end)=secaooffset.y(end)-c1;
        geom=polygeom(secaooffset.x,secaooffset.y);
        Ae(s)=geom(1);
        ue(s)=geom(4);
        
        d(:,s)=(ymaxv(s)-epv(:,s));
    end
    Astmin(s)=0.2*fctm/500*bwef(s)*100*100;
end

for lado=1:2
    for s=1:ss
        if d(lado,s)<.8*(ymaxv(s)-yminv(s))
            d(lado,s)=.8*(ymaxv(s)-yminv(s));
        end
        Vrd2(lado,s)= 0.27*(1-fck/250)*fck/gama_c/10*bwef(s)*100*d(lado,s)*100;%kN
        Trd2(lado,s)=(0.50*(1-fck/250)*fck/gama_c/10*Ae(s)*(10^4)*he(s)*100)/100;%kN.m
        Vc0(lado,s)=  0.60*fctd/10*bwef(s)*100*d(lado,s)*100;%kN
        
        Tsd=max([max(abs(sTmax(s))) abs(sTmin(s))]);
        Vsd=sVmax(s)-.9*Pinfv(lado,s)*sin(teta_hv(lado,s));
        combVT(lado,s)=Vsd/Vrd2(lado,s)+Tsd/Trd2(lado,s);
        if combVT(lado,s)>=1
            situacao=false;
            msg_erro=['Capacidade resistente a cortante e torção excedida. Longarina ' num2str(long_i) ', no vão ' num2str(vao_i) ', ' num2str(combVT(lado,s)*100) ' %%'];
            return
        end
        W1=-Iv(s)/yminv(s);
        M0(lado,s)=(0.9*Pinfv(lado,s))*W1/Av(s)+0.9*-epv(lado,s)*Pinfv(lado,s);%momento que nulifica as tensões no bordo comprimido
        if Mdmax(s)<=0
            beta1(lado,s)=1;
        else
            beta1(lado,s)=M0(lado,s)/Mdmax(s);
            if beta1(lado,s)>1
                beta1(lado,s)=1;
            end
        end
        Vc(lado,s)=((1+beta1(lado,s))*Vc0(lado,s));
        Vsw(lado,s)=Vsd-Vc(lado,s);
        if Vsw(lado,s)<0
            Vsw(lado,s)=0;
        end
        Asw_s(lado,s)= Vsw(lado,s)/.9/d(lado,s)/50*1.15;%cm²/m
        As90_s(lado,s)=Tsd/2/Ae(s)/50*1.15;%cm²/m
        
        % correção para fadiga
        
        Vcfmax=sVmaxCF(s);
        Vcfmin=sVminCF(s);
        Vsw1(lado,s)=Vcfmax-.9*Pinfv(lado,s)*sin(teta_hv(lado,s))-.5*Vc(lado,s);%kN
        if Vsw1(lado,s)<0
            Vsw1(lado,s)=0;
        end
        Vsw2(lado,s)=Vcfmin-.9*Pinfv(lado,s)*sin(teta_hv(lado,s))-.5*Vc(lado,s);%kN
        if Vsw2(lado,s)<0
            Vsw2(lado,s)=0;
        end
        
        if Asw_s(lado,s)==0
            sigsw1(lado,s)=0;
            sigsw2(lado,s)=0;
        else
            sigsw1(lado,s)=Vsw1(lado,s)/(Asw_s(lado,s)*.9*d(lado,s)*100)*10;%MPa
            sigsw2(lado,s)=Vsw2(lado,s)/(Asw_s(lado,s)*.9*d(lado,s)*100)*10;%MPa
        end
        deltasigsw(lado,s)=sigsw1(lado,s)-sigsw2(lado,s);%MPa
        if deltasigsw(lado,s)<85
            Aswcor(lado,s)=Asw_s(lado,s);
        else
            Aswcor(lado,s)=Asw_s(lado,s)*deltasigsw(lado,s)/85;
        end
        
        Tcfmax=sTmaxCF(s);
        Tcfmin=sTminCF(s);
        if As90_s(lado,s)==0
            deltasigswT(lado,s)=0;
        else
            if Tcfmax*Tcfmin<0%sinais diferentes
                Tcf=max(abs([Tcfmax Tcfmin]));
                deltasigswT(lado,s)=Tcf/(As90_s(lado,s)*2*Ae(s))*10;%MPa
            else
                deltasigswT(lado,s)=abs((Tcfmax-Tcfmin)/(As90_s(lado,s)*2*Ae(s))*10);%MPa
            end
        end
        
        if deltasigswT(lado,s)<85
            As90cor(lado,s)=As90_s(lado,s);
        else
            As90cor(lado,s)=As90_s(lado,s)*deltasigswT(lado,s)/85;
        end
        
        %juntando as duas armaduras considerando 2 pernas
        Astramo(lado,s)=Aswcor(lado,s)/2+As90cor(lado,s);

    end
%      figure(1321)
%      hold on
%      plot(sx,Astramo(lado,:))
%      plot(sx,Astmin(:))
end

for s=1:ss
    if Astmin(s)/2>max([Astramo(1,s) Astramo(2,s)])
        Ast(s)=Astmin(s)/2;
    else
        Ast(s)=max([Astramo(1,s) Astramo(2,s)]);
    end
    Aslt(s)=max([As90cor(1,s) As90cor(2,s)]); % REMOVIDO - Pele calculada no orçamento. 17.3.5.2.3 da 6118:2014 (bwef(s)+dcabo/2)*100*h1*100*.1/100
end
         
info.longarinas.vao(vao_i).longarina(long_i).Ast=Ast;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).Ast=Ast;

info.longarinas.vao(vao_i).longarina(long_i).Aslt=Aslt;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).Aslt=Aslt;

%% Perimetro para o orçamento

% Seção pré moldada sem offset
geom=polygeom(secaol(1:end-1,1),secaol(1:end-1,2));
ul=geom(4);

info.longarinas.vao(vao_i).longarina(long_i).ul=ul;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).ul=ul;

% Seção pré moldada enrijecida sem offset
geom=polygeom(secaolenr(1:end-1,1),secaolenr(1:end-1,2));
ulenr=geom(4);

info.longarinas.vao(vao_i).longarina(long_i).ulenr=ulenr;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).ulenr=ulenr;

% Seção pré moldada com offset igual a c1
[secaooffset.x,secaooffset.y]=offsetCurve(transpose(secaol(1:end-1,1)),transpose(secaol(1:end-1,2)), c1);
secaooffset.y(1)=secaooffset.y(1)-c1;
secaooffset.y(end)=secaooffset.y(end)-c1;
geom=polygeom(secaooffset.x,secaooffset.y);
uel=geom(4);

info.longarinas.vao(vao_i).longarina(long_i).uel=uel;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).uel=uel;

% Seção pré moldada enrijecida com offset igual a c1
[secaooffset.x,secaooffset.y]=offsetCurve(transpose(secaolenr(1:end-1,1)),transpose(secaolenr(1:end-1,2)), c1);
secaooffset.y(1)=secaooffset.y(1)-c1;
secaooffset.y(end)=secaooffset.y(end)-c1;
geom=polygeom(secaooffset.x,secaooffset.y);
uelenr=geom(4);

info.longarinas.vao(vao_i).longarina(long_i).uelenr=uelenr;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).uelenr=uelenr;


%% Cisalhamento na interface

[situacao, msg_erro] = avalia_cisalhamento_interface_longarina(Ast, As90cor, sx, lb, Msd, Mg2ek, gama_gd, h1, hlj, b1, viaduto.fyk, viaduto.gama_s, fck, gama_c, viaduto.comprimento_apoiado_pre_laje);
if not(situacao); return; end



end

function [situacao,msg_erro] = avalia_cisalhamento_interface_longarina(Ast, As90cor, sx, lb, Msd, Mg2ek, gama_gd, h1, hlj, b1, fyk, gama_s, fck, gama_c, comprimento_apoiado_pre_laje)
Ast_int = Ast*2 - max(As90cor); % cm²/m
delta_x = [(sx(2:end)-sx(1:end-1)) lb/2-sx(end)];
MSd_ext = Msd - Mg2ek*gama_gd; % kN.m
d = (h1+hlj)*.87*.9;
av = lb/2;
b = b1 - 2 * comprimento_apoiado_pre_laje;
fyd = fyk/gama_s * 10; % em MPa

[situacao,msg_erro] = avalia_cisalhamento_interface(Ast_int, delta_x, fck, gama_c, fyd, MSd_ext, d, av, b);

end




function [rbp, rep] = avalia_rotacao_apoio_protensao(ep, P, x, Ecs, I)
Mprot = ep .* P;
np = length(Mprot);

for i = 1 : np - 1
    a(i) = (Mprot(i+1) - Mprot(i))/(x(i+1) - x(i));
end

p = a(1:np-2)-a(2:np-1);


%% Constroi analise estrutural
nn = length(x);
nb = nn-1;

joints = zeros(nn,3);
joints(:,1) = transpose(x);

jb = [transpose(1:nn-1) transpose(2:nn)];

jfix = zeros(nn,6);
jfix(1,:) = [1 1 1 1 0 1]; 
jfix(end,:) = [1 1 1 1 0 1];

aflex = [];
broty = [];
brig = [];
brig_ex = [];
draw_not = [];

A = ones(1,nb); % Valor qualquer
E = ones(1,nb)*Ecs;
G = E; % Valor qualquer
Iz = ones(1,nb)*I; % Valor qualquer
Iy = ones(1,nb)*I;
J = ones(1,nb)*.05; % Valor qualquer

[nb,nn,lb,r,T] =...
    calc_cossenos(joints,jb);

%% Constroi carregamento
LC.jl = zeros(nn*6,1);
LC.cc = [];
LC.cd = [];
LC.ct = [];

LC.jl(01*6-6+5) = Mprot(1); % Primeiro Momento
LC.jl(nn*6-6+5) = -Mprot(end); % Ultimo momento

for n = 2 : nn-1
    LC.jl(n*6-6+3) = -p(n-1);
end

%% Analise Estrutural
relatorio_tempo = false;
[d] = AMEBP3D(nb,nn,lb,r,T,joints,jb,jfix,broty,LC,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,relatorio_tempo);


rbp = d(01*6-6+5);
rep = d(nn*6-6+5);
end






function [situacao,msg_erro] = avalia_aparelho_de_apoio_longarina(info, vao_i, long_i, viaduto, rbp, rep, ENVAPAPOIO)
%phi = info.longarinas.vao(vao_i).longarina(long_i).phi;
a = info.aparelhos_de_apoio.vao(vao_i).a*100;
b = info.aparelhos_de_apoio.vao(vao_i).b*100;
G = info.aparelhos_de_apoio.vao(vao_i).Gpad/100;
fyk = 2100;
cl = viaduto.pap.cl*100; % cm, Cobrimento lateral
ne = info.aparelhos_de_apoio.vao(vao_i).ne;
he = viaduto.pap.he*100;
ni = info.aparelhos_de_apoio.vao(vao_i).ni;
hi = info.aparelhos_de_apoio.vao(vao_i).hi*100;
h_total = viaduto.vao(vao_i).hap * 100;
hs = viaduto.pap.s *100;

g = 9.806;
for i = 1:2
    switch i
        case 1
            rp = rbp;
        case 2
            rp = rep;
    end
    Fg = abs(min(ENVAPAPOIO.aparelho_de_apoio(i).MIN.Fg)) /g; % kgf
    Fq = abs(min(ENVAPAPOIO.aparelho_de_apoio(i).MIN.Fq)) /g; % kgf
    Hg = max(abs([ENVAPAPOIO.aparelho_de_apoio(i).MAX.Hg ENVAPAPOIO.aparelho_de_apoio(i).MIN.Hg])) /g; % kgf
    Hq = max(abs([ENVAPAPOIO.aparelho_de_apoio(i).MAX.Hq ENVAPAPOIO.aparelho_de_apoio(i).MIN.Hq])) /g; % kgf
    alfa_g_max = ENVAPAPOIO.aparelho_de_apoio(i).MAX.alfa_g+rp;
    alfa_g_min = ENVAPAPOIO.aparelho_de_apoio(i).MIN.alfa_g+rp;
    alfa_q_max = ENVAPAPOIO.aparelho_de_apoio(i).MAX.alfa_q;
    alfa_q_min = ENVAPAPOIO.aparelho_de_apoio(i).MIN.alfa_q;

    for j = 1:2
        switch i
            case 1
                alfa_g = alfa_g_max;
                alfa_q = alfa_q_max;
            case 2
                alfa_g = alfa_g_min;
                alfa_q = alfa_q_min;
        end
        [situacao, msg_erro] = avalia_aparelho_de_apoio(a, b, Fg, Fq, Hg, Hq, alfa_g, alfa_q, G, fyk, cl, ne, he, ni, hi, h_total, hs);
        if not(situacao); return; end
    end
end
end

function [situacao, msg_erro, info] = confere_flecha_longarina(xb, tot_ponto, mlong, xcabo, epl, Pime, Mg2e, MFLECHA, t, DMLG, viaduto, fck, s_cim, alfa_e, Iyl, Iyll, info, vao_i, long_i, psi_2)
lx = xb(1:tot_ponto(mlong),mlong);
lxp = xcabo(2:end-1);
ep = epl(2:end-1);
P = Pime(2:end-1); % kN
Mg1 = Mg2e; % kN.m
Mg23 = MFLECHA.PP/1000-Mg2e; % kN.m
MP = ep.*P;% kN.m
MMULT = MFLECHA.MULT/1000;% kN.m
MVEIC = MFLECHA.VEIC/1000;% kN.m
tP=t;
tPP=DMLG;
mult_flecha_peso_proprio = viaduto.mult_flecha_peso_proprio;
mult_flecha_acoes_permanentes = viaduto.mult_flecha_acoes_permanentes;
mult_flecha_protensao = viaduto.mult_flecha_protensao;
mult_flecha_acoes_variaveis = viaduto.mult_flecha_acoes_variaveis;

limite_l_sobre_flecha_ativa = viaduto.limite_l_sobre_flecha_ativa;
limite_l_sobre_flecha_diferida = viaduto.limite_l_sobre_flecha_diferida;



[flecha_ativa, flecha_diferida,situacao,msg_erro] = confere_limite_flecha(lx, Mg1, fck, tPP, s_cim, alfa_e, Iyl, Iyll, Mg23, lxp, MP, tP, MMULT, MVEIC, psi_2, limite_l_sobre_flecha_ativa, mult_flecha_protensao, mult_flecha_peso_proprio, mult_flecha_acoes_permanentes, mult_flecha_acoes_variaveis, limite_l_sobre_flecha_diferida);




info.longarinas.vao(vao_i).longarina(long_i).flecha_ativa = flecha_ativa;
info.longarinas.vao(vao_i).longarina(long_i).flecha_diferida = flecha_diferida;
end