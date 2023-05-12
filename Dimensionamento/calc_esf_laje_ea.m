function [Mxmd,Mymd,Mxed,Mxm_CF_max,Mym_CF_max,Mxe_CF_max,Mxm_CF_min,Mym_CF_min,Mxe_CF_min,Vsd,VCF_max,VCF_min,situacao,msg_erro]=calc_esf_laje_ea(lx,ly,b1,h_pav,h_laje,CIV,tMxml,tMyml,tMxel,tMxmp,tMymp,tMxep,tMxmpl,tMympl,tMxepl)
%Calcula os esforços na laje
situacao=true;
msg_erro='sem erro';
Mxmd=0;
Mymd=0;
Mxed=0;
Mxm_CF_max=0;
Mym_CF_max=0;
Mxe_CF_max=0;
Mxm_CF_min=0;
Mym_CF_min=0;
Mxe_CF_min=0;
Vsd=0;
VCF_max=0;
VCF_min=0;

Pv=75;% Carga concentrada da roda do veículo tipo em kN
Qv=5; % Carga distribuida de multidão em kN/m²


contatofic=(.5*.2)^(1/2);               %Aproximando roda retangular para quadrada
tcentro=contatofic+2*(h_pav+h_laje/2);  %Largura da roda apos o espraiamento
a=2;                                    %Distancia entre rodas do veiculo tipo
lxsobrea=lx/a;
tsobrea=tcentro/a;
pplaje=h_laje*25;%kN/m²
pppavi=h_pav*24;%kN/m²
cargpermtotal=pplaje+pppavi+2;%kN/m²
config_Mc
psi1_fadiga_laje=.8; %Pontes rodoviárias - Laje do tabuleiro

%% Flexão
if tsobrea<.125 || tsobrea>=1 || lxsobrea<.5 || lxsobrea>=10
    situacao=false;
    msg_erro='Formato da laje fora do padrão da tabela de Rusch';
    return
end



% contx=0;
% for tsobrea=.125:(1*.99-.125)/100:1*.99
%     contx=contx+1;
%     conty=0;
%     for lxsobrea=.5:(10*.99-.5)/100:10*.99
%          conty=conty+1;
%          tsobreai(contx,conty)=tsobrea;
%          lxsobreai(contx,conty)=lxsobrea;
         

[Mxml,Myml,Mxel,Mxmp,Mymp,Mxep,Mxmpl,Mympl,Mxepl]=...
    interp_tabela_rusch(lxsobrea,tsobrea,tMxml,tMyml,tMxel,tMxmp,tMymp,tMxep,tMxmpl,tMympl,tMxepl,gama_gd);


%                 Mxmli(contx,conty)=Mxml_ee;
%                 Mymli(contx,conty)=Myml_ee;
%                 Mxeli(contx,conty)=Mxel_ee;
%                 Mxmpi(contx,conty)=Mxmp_ee;
%                 Mympi(contx,conty)=Mymp_ee;
%                 Mxepi(contx,conty)=Mxep_ee;
%                 Mxmpli(contx,conty)=Mxmpl_ee;
%                 Mympli(contx,conty)=Mympl_ee;
%                 Mxepli(contx,conty)=Mxepl_ee;
% 
%    end
% end
% surf(tsobreai,lxsobreai,Mxmli)
% surf(tsobreai,lxsobreai,Mymli)
% surf(tsobreai,lxsobreai,Mxeli)
% surf(tsobreai,lxsobreai,Mxmpi)
% surf(tsobreai,lxsobreai,Mympi)
% surf(tsobreai,lxsobreai,Mxepi)
% surf(tsobreai,lxsobreai,Mxmpli)
% surf(tsobreai,lxsobreai,Mympli)
% surf(tsobreai,lxsobreai,Mxepli)

%Para Momento Transversal à ponte no meio da laje (Mxm)

if ly<20
    correcao_alfa=1.2/(1+ly/100);
else
    correcao_alfa=1;
end

kxm = .0625;
kym = .0104;
kxe = .1250;%1/8

correcao_alfa_zero_xm = 1.1;
correcao_alfa_zero_ym = 1.1;
correcao_alfa_zero_xe = 1.0;


Mxmqk=CIV*(Pv*Mxml+Qv*Mxmp+Qv*Mxmpl);%kN.m/m
Mxmgk=kxm*lx^2*cargpermtotal;%kN.m/m
Mxmd=(Mxmqk*gama_q+Mxmgk*gama_gd) * correcao_alfa_zero_xm * correcao_alfa;

Mymqk=CIV*(Pv*Myml+Qv*Mymp+Qv*Mympl);%kN.m/m
Mymgk=kym*lx^2*cargpermtotal;%kN.m/m
Mymd=(Mymqk*gama_q+Mymgk*gama_gd) * correcao_alfa_zero_ym * correcao_alfa;

Mxeqk=CIV*(Pv*Mxel+Qv*Mxep+Qv*Mxepl);%kN.m/m
Mxegk=kxe*lx^2*cargpermtotal;%kN.m/m
Mxed=(Mxeqk*gama_q+Mxegk*gama_gd) * correcao_alfa_zero_xe * correcao_alfa;


Mxm_CF_max = (Mxmgk + Mxmqk * psi1_fadiga_laje) * correcao_alfa_zero_xm * correcao_alfa;
Mym_CF_max = (Mymgk + Mymqk * psi1_fadiga_laje) * correcao_alfa_zero_ym * correcao_alfa;
Mxe_CF_max = (Mxegk + Mxeqk * psi1_fadiga_laje) * correcao_alfa_zero_xe * correcao_alfa;
Mxm_CF_min = Mxmgk * correcao_alfa_zero_xm * correcao_alfa;
Mym_CF_min = Mymgk * correcao_alfa_zero_ym * correcao_alfa;
Mxe_CF_min = Mxegk * correcao_alfa_zero_xe * correcao_alfa;


%% Esforço cortante

tx=50+2*(h_pav*100+h_laje/2*100); % cm
ty=20+2*(h_pav*100+h_laje/2*100); % cm

dist_roda_long=(b1 * 100 / 2 + tx / 2); % cm

bm=ty+0.3*dist_roda_long;           % Largura do espraiamento da carga da roda 1 até o eixo da longarina - Largura útil para força cortante, segundo a norma alemã Deutscher Ausschuss für Stahlbeton – Heft 240 
if bm>150
    situacao=false;
    msg_erro='Os dois eixos do veículo tipo solicitam o mesmo trecho da laje'
    return
end
bm2=ty+0.3*(dist_roda_long + 200);  % Largura do espraiamento da carga da roda 2 até o eixo da longarina

% Roda 1 é a roda proxima a longarina
% Roda 2 é a segunda roda do eixo

% Caso 1 - Veículo proximo a extremidade apoiada da laje

xcisa1 = dist_roda_long;                         % Posição da carga da roda 1 em centimetros
xcisa2 = dist_roda_long + 200;                   % Posição da carga da roda 2 em centimetros


[Vsd_caso1,VCF_max_caso1,VCF_min_caso1]=calc_esforco_cortante(lx,bm,bm2,Pv,Qv,cargpermtotal,CIV,xcisa1,xcisa2,gama_q,gama_gd,psi1_fadiga_laje);

% Caso 2 - Veículo proximo a extremidade engastada da laje
xcisa1 = (lx * 100) - dist_roda_long;            % Posição da carga da roda 1 em centimetros
xcisa2 = xcisa1 - 200;                           % Posição da carga da roda 2 em centimetros


[Vsd_caso2,VCF_max_caso2,VCF_min_caso2]=calc_esforco_cortante(lx,bm,bm2,Pv,Qv,cargpermtotal,CIV,xcisa1,xcisa2,gama_q,gama_gd,psi1_fadiga_laje);

% Pega os valores maximos
[Vsd,indice] = max([Vsd_caso1 Vsd_caso2]);

VCF_max_caso12 = [VCF_max_caso1 VCF_max_caso2];
VCF_min_caso12 = [VCF_min_caso1 VCF_min_caso2];

VCF_max = VCF_max_caso12(indice);
VCF_min = VCF_min_caso12(indice);

end

function [Vsd,VCF_max,VCF_min]=calc_esforco_cortante(lx,bm,bm2,Pv,Qv,cargpermtotal,CIV,xcisa1,xcisa2,gama_q,gama_gd,psi1_fadiga_laje) 

F1=Pv;
F2=0;                               % Se a carga fica depois da viga ou antes da viga ela entra com força igual a zero
if and(xcisa2 < lx * 100, xcisa2 > 0)
    F2=Pv*bm/bm2;                   % Reduz a carga da roda 2 considerando que seu espraiamento é maior
end

% Carga variavel
[Ra1Pq, Rb1Pq] = calc_reacao_carga_concentrada(-F1, (lx * 100), xcisa1); % Reações da roda 1 em kN
[Ra2Pq, Rb2Pq] = calc_reacao_carga_concentrada(-F2, (lx * 100), xcisa2); % Reações da roda 2 em kN

RaPq = Ra1Pq + Ra2Pq; % Reação no apoio a
RbPq = Rb1Pq + Rb2Pq; % Reação no apoio b

[RaQq, RbQq]   = calc_reacao_carga_distribuida(-Qv / 100, (lx * 100), 0, 0); % Reações da carga distribuida variavel



% Carga permanente
[Vagk, Vbgk] = calc_reacao_carga_distribuida(-cargpermtotal / 100, (lx * 100), 0, 0); % Reações da carga distribuida permanente

Vaqk = (RaPq / (bm / 100) + RaQq) * CIV; % Força cortante em a por metro de largura caracteristica
Vbqk = (RbPq / (bm / 100) + RbQq) * CIV; % Força cortante em b por metro de largura caracteristica

% Esforços de cálculo
% Ultimos
Vasd = Vaqk * gama_q + Vagk * gama_gd;
Vbsd = Vbqk * gama_q + Vbgk * gama_gd;

[Vsd, indice] = max(abs([Vasd Vbsd]));
% Combinação frequente máxima
VCF_max_ab = [(Vaqk * psi1_fadiga_laje + Vagk) (Vbqk * psi1_fadiga_laje + Vbgk)];
VCF_max = VCF_max_ab(indice);

% Combinação frequente mínima
VCF_min_ab = [Vagk Vbgk];
VCF_min = VCF_min_ab(indice);
    
end

function [Ra, Rb] = calc_reacao_carga_distribuida(Q, L, a, b)

c = L - a - b;

M_eng = - Q / (8 * L ^ 2) * (a ^ 4 - (a + c) ^ 4 + 2 * c * L ^ 2 * (2 * a + c));

F_total = Q * c;
Ra = - F_total * ((L - (a + c / 2)) / L) - M_eng / L;
Rb = - F_total - Ra;

end

function [Ra, Rb] = calc_reacao_carga_concentrada(P, L, a)

b = L - a;
M_eng = - (P*a*b)/(2*L^2)*(L+a);

F_total = P;
Ra = - P * (b/L) - M_eng/L;
Rb = - F_total - Ra;

end

function [Mxml,Myml,Mxel,Mxmp,Mymp,Mxep,Mxmpl,Mympl,Mxepl]=interp_tabela_rusch(lxsobrea,tsobrea,tMxml,tMyml,tMxel,tMxmp,tMymp,tMxep,tMxmpl,tMympl,tMxepl,gama_gd)
for contc=2:1:4
    if tsobrea>=tMxml(1,contc) && tsobrea<tMxml(1,contc+1)
        for contl=2:1:14
            if lxsobrea>=tMxml(contl,1) && lxsobrea<=tMxml(contl+1,1)
                v1=(tMxml(contl,contc)-tMxml(contl,contc+1))*(tMxml(1,contc+1)-tsobrea)/(tMxml(1,contc+1)-tMxml(1,contc))+tMxml(contl,contc+1);
                v2=(tMxml(contl+1,contc)-tMxml(contl,contc))/(tMxml(contl+1,1)-tMxml(contl,1))*(lxsobrea-tMxml(contl,1))+tMxml(contl,contc);
                v3=(tMxml(contl+1,contc)-tMxml(contl+1,contc+1))*(tMxml(contl,contc+1)-v1)/(tMxml(contl,contc+1)-tMxml(contl,contc))+tMxml(contl+1,contc+1);
                Mxml=(v3-v1)/(tMxml(contl+1,contc)-tMxml(contl,contc))*(v2-tMxml(contl,contc))+v1;

                v1=(tMyml(contl,contc)-tMyml(contl,contc+1))*(tMyml(1,contc+1)-tsobrea)/(tMyml(1,contc+1)-tMyml(1,contc))+tMyml(contl,contc+1);
                v2=(tMyml(contl+1,contc)-tMyml(contl,contc))/(tMyml(contl+1,1)-tMyml(contl,1))*(lxsobrea-tMyml(contl,1))+tMyml(contl,contc);
                v3=(tMyml(contl+1,contc)-tMyml(contl+1,contc+1))*(tMyml(contl,contc+1)-v1)/(tMyml(contl,contc+1)-tMyml(contl,contc))+tMyml(contl+1,contc+1);
                Myml=(v3-v1)/(tMyml(contl+1,contc)-tMyml(contl,contc))*(v2-tMyml(contl,contc))+v1;

                v1=(tMxel(contl,contc)-tMxel(contl,contc+1))*(tMxel(1,contc+1)-tsobrea)/(tMxel(1,contc+1)-tMxel(1,contc))+tMxel(contl,contc+1);
                v2=(tMxel(contl+1,contc)-tMxel(contl,contc))/(tMxel(contl+1,1)-tMxel(contl,1))*(lxsobrea-tMxel(contl,1))+tMxel(contl,contc);
                if (tMxel(contl,contc+1)-tMxel(contl,contc))==0
                    v3=tMxel(contl+1,contc+1);
                else
                    v3=(tMxel(contl+1,contc)-tMxel(contl+1,contc+1))*(tMxel(contl,contc+1)-v1)/(tMxel(contl,contc+1)-tMxel(contl,contc))+tMxel(contl+1,contc+1);
                end
                Mxel=(v3-v1)/(tMxel(contl+1,contc)-tMxel(contl,contc))*(v2-tMxel(contl,contc))+v1;

                
                
                Mxmp=(tMxmp(contl+1,2)-tMxmp(contl,2))/(tMxmp(contl+1,1)-tMxmp(contl,1))*(lxsobrea-tMxmp(contl,1))+tMxmp(contl,2);
                
                Mymp=(tMymp(contl+1,2)-tMymp(contl,2))/(tMymp(contl+1,1)-tMymp(contl,1))*(lxsobrea-tMymp(contl,1))+tMymp(contl,2);
                
                Mxep=(tMxep(contl+1,2)-tMxep(contl,2))/(tMxep(contl+1,1)-tMxep(contl,1))*(lxsobrea-tMxep(contl,1))+tMxep(contl,2);

                Mxmpl=(tMxmpl(contl+1,2)-tMxmpl(contl,2))/(tMxmpl(contl+1,1)-tMxmpl(contl,1))*(lxsobrea-tMxmpl(contl,1))+tMxmpl(contl,2);
                
                Mympl=(tMympl(contl+1,2)-tMympl(contl,2))/(tMympl(contl+1,1)-tMympl(contl,1))*(lxsobrea-tMympl(contl,1))+tMympl(contl,2);
                
                Mxepl=(tMxepl(contl+1,2)-tMxepl(contl,2))/(tMxepl(contl+1,1)-tMxepl(contl,1))*(lxsobrea-tMxepl(contl,1))+tMxepl(contl,2);
                
                

                break
            end
        end
        break
    end
end
end
