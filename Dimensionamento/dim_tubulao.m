function [diam,ht,tensao_adm,Nspt_bulbo,situacao,msg_erro]=dim_tubulao(Nsk,Nspt,ro_s,x_fund,z_fund,diam_fuste,z_superficie)
% Dimensiona o tubulão de acordo com Jose Carlos Cintra, Nelson Aoki e José Henrique Albiero

diam=0;

ht=0;
situacao=true;
msg_erro='sem erro';

Nsk=double(Nsk);

sobrecarga=calc_sobrecarga(ro_s,x_fund,z_fund,z_superficie);

diam=1;%diametro inicial

for n=1:5
    [tensao_adm,Nspt_bulbo,situacao,msg_erro]=calc_tensao_adm(sobrecarga,diam,Nspt,x_fund,z_fund);
    if not(situacao); return; end
    
    diam=sqrt((Nsk/tensao_adm)*4/pi);    
end

if Nspt_bulbo<5 
    situacao=false;
    msg_erro='N_spt no bulbo menor que 5 golpes';
    return
end


if diam<diam_fuste
    diam=diam_fuste;
end

a=diam/2-diam_fuste/2;

ht=a/tand(30);

if ht < .3
    ht = .3;
end

if ht>1.8 
    situacao=false;
    msg_erro='Altura do alargamento da base do tubulão maior que 1.80 m';
    return
end




end


function [tensao_adm,Nspt_bulbo,situacao,msg_erro]=calc_tensao_adm(sobrecarga,diam,Nspt,x_fund,z_fund)
tensao_adm=0;
situacao=true;
msg_erro='sem erro';

B=2*diam;%dimensão do bulbo de tensões, 2x o diametro de acordo com Cintra Aoki e Albiero


Nspt_bulbo=calc_Nspt_bulbo(B,Nspt,x_fund,z_fund);



if Nspt_bulbo>20
    Nspt_bulbo=20;
end

tensao_adm=Nspt_bulbo/50*1000+sobrecarga;%kPa

end


function Nspt_bulbo=calc_Nspt_bulbo(B,Nspt,x_fund,z_fund)
disc=20;%numeros de trechos na discretizacao
l=B/disc;
Nspt_bulbo_disc=zeros(1,disc);


z=z_fund-l/2;%inicializa

for i=1:disc
    Nspt_bulbo_disc(i)=Nspt(x_fund,z);
    z=z-l;
end

Nspt_bulbo=mean(Nspt_bulbo_disc);
end


function sobrecarga=calc_sobrecarga(ro_s,x_fund,z_fund,z_superficie)
disc=20;%numeros de trechos na discretizacao
L=z_superficie-z_fund;
l=L/disc;
ro_s_disc=zeros(1,disc);


z=z_fund+l/2;%inicializa

for i=1:disc
    ro_s_disc(i)=ro_s(x_fund,z);
    z=z+l;
end
ro_s_med=mean(ro_s_disc);


sobrecarga=ro_s_med*L;%kPa


end