function [Ast,Aslt,situacao,msg_erro] = dim_cisalhamento(Vsd,VCF_max,VCF_min,Tsd,TCF_max,TCF_min,Nsd,d,A,u,Ae,I,bw,c1,ymin,Mdmax,fck,gama_c)
%Dimensionamento de seção a cortante e torção
%   Unidades de entrada em metros e kN e MPa

Ast=0;
Aslt=0;
situacao=true;
msg_erro='sem erro';


[fctm,fctkinf,~] = calc_fctm(fck);
fctd=fctkinf/gama_c;


he=2*c1;
Asobreu=A/u;

if he>Asobreu
    he=Asobreu;
    if Asobreu>bw
        he=bw;
    end
end

Astmin=0.2*fctm/500*bw*100*100;

%% Verificação de esforço cortante e de torção combinados

Vrd2 = calc_Vrd2(fck,gama_c,bw*100,d*100); % kN
Trd2=(0.50*(1-fck/250)*fck/gama_c/10*Ae*(10^4)*he*100)/100;%kN.m
Vc0 = calc_Vc0(fctd, bw*100, d*100); % kN

combVT=Vsd/Vrd2+Tsd/Trd2;
if combVT>=1
    situacao=false;
    msg_erro=['Capacidade resistente a cortante e torção excedida, ' num2str(combVT*100) ' %%'];
    return
end


%% Dimensionamento para esforço cortante
W1=-I/ymin;
M0=(-Nsd)*W1/A;%momento que nulifica as tensões no bordo comprimido
        
if Mdmax<=0
    beta1=1;
else
    beta1=M0/Mdmax;
    if beta1>1
        beta1=1;
    end
end

Vc=(1+beta1)*Vc0;
Vsw=Vsd-Vc;
if Vsw<0
    Vsw=0;
end

Asw_s=Vsw/.9/d/50*1.15;%cm²/m % Modelo I da NBR 6118:2014


%% Dimensionamento para esforço de torção

As90_s=Tsd/2/Ae/50*1.15;%cm²/m

%% Correção para fadiga esforço cortante

Vsw1=VCF_max-.5*Vc;%kN
if Vsw1<0
    Vsw1=0;
end
Vsw2=VCF_min-.5*Vc;%kN
if Vsw2<0
    Vsw2=0;
end

if Asw_s==0
    sigsw1=0;
    sigsw2=0;
else
    sigsw1=Vsw1/(Asw_s*.9*d*100)*10;%MPa
    sigsw2=Vsw2/(Asw_s*.9*d*100)*10;%MPa
end

deltasigsw=sigsw1-sigsw2;%MPa

if deltasigsw<85
    Aswcor=Asw_s;
else
    Aswcor=Asw_s*deltasigsw/85;
end

%% Correção para fadiga esforço de torção

if As90_s==0
    deltasigswT=0;
else
    if TCF_max*TCF_min<0%sinais diferentes
        TCF=max(abs([TCF_max TCF_min]));
        deltasigswT=TCF/(As90_s*2*Ae)*10;%MPa
    else
        deltasigswT=abs((TCF_max-TCF_min)/(As90_s*2*Ae)*10);%MPa
    end
end

if deltasigswT<85
    As90cor=As90_s;
else
    As90cor=As90_s*deltasigswT/85;
end
Aslt=As90cor;
%% juntando as duas armaduras considerando 2 pernas

Astramo=Aswcor/2+As90cor;


if Astmin/2>Astramo
    Ast=Astmin/2;
else
    Ast=Astramo;
end



end

