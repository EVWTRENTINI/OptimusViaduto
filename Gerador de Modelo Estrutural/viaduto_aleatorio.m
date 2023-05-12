viaduto.W=16.2;%m
viaduto.L=60;%m
viaduto.n_apoios=1+randi(3);
viaduto.hpav=.1;%m
config_padrao_viaduto 
for i=1:viaduto.n_apoios
    viaduto.apoio(i).cota_greide=7.85;
    viaduto.apoio(i).cota_arrasamento=0;
    viaduto.apoio(i).cota_fundacao=-6-randi(5);
    viaduto.apoio(i).hap=.05;%m - altura aparelho de apoio
    viaduto.apoio(i).kap=100000;%N/m  rigidez aparelho de apoio
    viaduto.apoio(i).n_pilares=1+randi(5);
    viaduto.apoio(i).fustes.d=.6;%m
    viaduto.apoio(i).fustes.fck=20E6;%Pa
    viaduto.apoio(i).pilares.d=.5+randi(8)/10;%m
    viaduto.apoio(i).pilares.fck=30E6;%Pa
    viaduto.apoio(i).travessa.h=1+randi(10)/10;%m
    viaduto.apoio(i).travessa.b=1+randi(10)/10;%m
    viaduto.apoio(i).travessa.bl=randi(4)/2;%m 
  
    viaduto.apoio(i).travessa.fck=30E6;%Pa
    
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=viaduto.L/(viaduto.n_apoios-1)-10+randi(20);%m
    viaduto.vao(i).n_longarinas=2+randi(6);
    viaduto.vao(i).laje.h=.17+randi(8)/100;%m
    viaduto.vao(i).laje.fck=30E6;%Pa
    viaduto.vao(i).longarina.b1=.6+randi(20)/20;%m
    viaduto.vao(i).longarina.b2=.1+randi(3)/20;%m
    viaduto.vao(i).longarina.b3=.3+randi(10)/20;%m
    viaduto.vao(i).longarina.h1=1+randi(15)/10;%m
    viaduto.vao(i).longarina.h2=.06+randi(12)/100;%m
    viaduto.vao(i).longarina.h3=.04+randi(12)/100;%m
    viaduto.vao(i).longarina.h4=.1+randi(20)/100;%m
    viaduto.vao(i).longarina.h5=.15+randi(20)/100;%m
    viaduto.vao(i).longarina.fck=35E6;%Pa
    viaduto.vao(i).longarina.c=.03;%m
end

if viaduto.n_apoios==2
    
    viaduto.apoio(2)=viaduto.apoio(1);
end

viaduto.vao(viaduto.n_apoios-1).l=viaduto.L-sum([viaduto.vao(1:end-1).l]);

[MA,info]=cria_viaduto(viaduto);
clear i 