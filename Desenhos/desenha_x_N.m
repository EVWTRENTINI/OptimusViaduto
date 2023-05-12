function [] = desenha_x_N(viaduto,MA,info)
%
%

vao_i=1;%qual vão
long_i=1;%qual longarina é verificada
mlong=info.longarinas.vao(vao_i).longarina(long_i).membros;
cgas=viaduto.vao(vao_i).longarina(long_i).cgas;
c=viaduto.vao(vao_i).longarina(long_i).c;
fck=viaduto.vao(vao_i).longarina(long_i).fck/1E6;%MPa
fck=30



secao=MA.memb(mlong).secao;
secao(:,1)=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PARA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TESTE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%secao=[-.5 1;-.5 -1;.5 -1;.5 1;-.5 1]; %retangular
%secao=[-2 -1;-1 -1;-1 -0.05;-1.15 -0.05;-1.40 -0;-1.60 -0;-1.85 -0.05;-2.000 -0.05;-2 -1]; %traprezio segundo exemplo
%secao=[.5 0;.5 .5;.35 .5;.1 1;-.1 1;-.35 .5;-.5 .5;-.5 0;.5 0] % trapezoidal para comparar com MN_laje
%secao=[.5 0;.5 .5;.35 .5;.1 1;-.1 1;-.35 .5;-.5 .5;-.5 0;.5 0] % trapezoidal para comparar com MN_laje ex 5 e 6
secao=[-.1 -.2;.1 -.2;.1 .2;-.1 .2;-.1 -.2]; %retangular padrao oblqcalco

%Aço passivo viga retangular inicio
ap.x=[-.07 .07 .07 -.07];
ap.y=[-.17 -.17 .17 .17];
ap.A=[1 1 1 1];%cm²
[~,ap.n]=size(ap.A);
%Aço passivo viga retangular fim


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parametros_concreto
[Nrdmax,Nrdmin] = Nrdmax_Nrdmin(secao,ap,fcd,Epc2);

contt=0;
figure(1)
for Nsd=Nrdmax:-abs((Nrdmax-Nrdmin*.98)/200):Nrdmin*.98
    contt=contt+1;
[Mrd,situacao,msg_erro,xa] = calc_Mrd(secao,fck,ap,Nsd);
drawnow
x(contt)=xa;
N(contt)=Nsd;
end
figure(2)
plot(x,N);

end









