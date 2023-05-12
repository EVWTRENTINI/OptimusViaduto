function [DelSigp] = calc_perca_encurtamento_elastico(s,cabo_eq,Mg0,secao,A,I,ntc,fck,viaduto)
%
%
alfa_e=viaduto.alfa_e;
Eci= calc_Eci(fck*1E6,alfa_e);%N/m² ou Pa modulo de elasticidade concreto
Eci=Eci/1000/(100^2);%kN/cm²
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade aço ativo
alfa_p=Ep/Eci;
e=min(secao(:,2))+cabo_eq.y(s);
y=e;
Sigcg=-Mg0(s)*y/I/(10^6);%MPa
P=cabo_eq.Sig(s)*cabo_eq.A;%kN
P=P*1000;%Newton
Sigcp=(-P/A+-(P*e)*y/I)/(10^6);%MPa

DelSigp=alfa_p*(-Sigcg-Sigcp)*((ntc-1)/(2*ntc));
end

