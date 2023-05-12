function [Mxmd,Mymd,Mxed,Mxm_CF_max,Mym_CF_max,Mxe_CF_max,Mxm_CF_min,Mym_CF_min,Mxe_CF_min,Vsd,VCF_max,VCF_min,situacao,msg_erro]=calc_esf_laje_ee(lx,ly,b1,h_pav,h_laje,CIV,tMxml,tMyml,tMxel,tMxmp,tMymp,tMxep,tMxmpl,tMympl,tMxepl)
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

kxm = 1/24;
kym = .0069;
kxe = 1/12;

correcao_alfa_zero_xm = 1.23;
correcao_alfa_zero_ym = 1.23;
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

tx=50+2*(h_pav*100+h_laje/2*100);%cm
ty=20+2*(h_pav*100+h_laje/2*100);%cm

xcisa=b1*100/2+tx/2;
bm=ty+0.3*xcisa;
if bm>150
    situacao=false;
    msg_erro='Os dois eixos do veículo tipo solicitam o mesmo trecho da laje'
    return
end
bm2=ty+0.3*(xcisa+200);
F1=Pv;
F2=0;
if lx>xcisa/100+2 % Se a carga fica depois da viga ela entra com força igual a zero
    F2=Pv*bm/bm2;
end
Va=F1*(lx*100-xcisa)/lx/100+F2*(lx*100-(xcisa+200))/lx/100;%kN/eixo
Vqk=(Va/(bm/100)+Qv*lx/2)*CIV; %kN/m
Vgk=cargpermtotal*lx/2;        %kN/m

Vsd=Vqk*gama_q+Vgk*gama_gd;
VCF_max=Vqk*psi1_fadiga_laje+Vgk;
VCF_min=Vgk;

    
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
