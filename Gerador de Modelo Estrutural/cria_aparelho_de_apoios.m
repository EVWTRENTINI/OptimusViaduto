function [info_aparelhos_de_apoio,situacao,msg_erro]=cria_aparelho_de_apoios(viaduto)
%Calcula a rigidez do aparelho de apoio
%   Calcula a rigidez transversal de acordo com Yazdani et all (2000) e de
%   rotação de acordo com a abordagem de Pablo Augusto Krahl (2020), mais
%   moderna considerando distribuição não linear da rigiez.
%   
%
%   Yazdani et all (2000)
%   EFFECT OF BEARING PADS ON PRECAST PRESTRESSED CONCRETE BRIDGES
%
%   Pablo Augusto Krahl (2020)
%   Simplified Analytical Nonlinear Model for Contact Problem between Prec-
%   ast Concrete Beams and Elastomeric Bearing Pads
%
%   A nomenclatura das variaveis aqui utilizadas se basea o livro
%   Pontes de concreto - Mounir Khalil El Debs



situacao=true;
msg_erro='sem erro';
info_aparelhos_de_apoio=struct();


for k=1:viaduto.n_apoios-1

    b3=viaduto.vao(k).longarina.b3;
    s=viaduto.pap.s;
    hap=viaduto.vao(k).hap;
    himax=viaduto.pap.himax;
    dureza=viaduto.pap.dureza;
    
    
    b=b3-viaduto.pap.fb;
    a=b*viaduto.pap.a_sobre_b;
    

    ne=2;
    he=viaduto.pap.he;

     
    hap_min=2*he+1*s;
    if hap<hap_min
        situacao=false;
        msg_erro=['Altura muito pequena do aparelho de apoio no vão ' num2str(k) '.'];
        return
    end

    ni=ceil((hap-2*he-s)/(s+himax));
    hi=(hap-2*he-s-s*ni)/ni;
    
    H=hap-(1+ni)*s; %17/05/22 - A altura não conta o aço.
    
    beta_i=a*b/(2*hi*(a+b));
    beta_e=a*b/(2*he*(a+b));
    
    beta=(ni*hi*beta_i+ne*he*beta_e)/(ni*hi+ne*he);
    
    Gpad=interp1([50 60 70],[800 1000 1200],dureza);%kN/m^2 - ABNT NBR 9062 apud Pontes de concreto - Mounir Khalil El Debs
    %Gpad=interp1([50 60 70],[680 930 1430],dureza);%kN/m^2 - AASHTO 1996, pagina 404 do pdf
    kd=interp1([50 60 70],[.75 .60 .55],dureza);%AASHTO 1996, pagina 404 do pdf
    
    %EFFECT OF BEARING PADS ON PRECAST PRESTRESSED CONCRETE BRIDGES
    %https://sci-hub.se/https://doi.org/10.1061/(ASCE)1084-0702(2000)5:3(224)
    khap=Gpad*(a*b)/H;
    Epad=3*Gpad*(1+kd*beta^2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %Pablo Augusto Krahl (2020)
    %Simplified Analytical Nonlinear Model for Contact Problem between  
    %Precast Concrete Beams and Elastomeric Bearing Pads
    ktap=Epad*a*b^3/(20*H);%kN.m/rad
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    info_aparelhos_de_apoio.vao(k).b=b;
    info_aparelhos_de_apoio.vao(k).a=a;
    info_aparelhos_de_apoio.vao(k).ne=ne;
    info_aparelhos_de_apoio.vao(k).he=he;
    info_aparelhos_de_apoio.vao(k).ni=ni;
    info_aparelhos_de_apoio.vao(k).hi=hi;
    info_aparelhos_de_apoio.vao(k).khap=khap;
    info_aparelhos_de_apoio.vao(k).ktap=ktap;
    info_aparelhos_de_apoio.vao(k).Gpad=Gpad;
end


end