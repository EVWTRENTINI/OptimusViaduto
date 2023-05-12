function [SN,SM] = equacao_equilibrio(fcd,n_conc,EpA,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd)
    d=vmax-min(ap.y); 
    [Nc,Mc]   = Nc_Mc(fcd,n_conc,EpA,xa,Epap,d,Epcu,Epc2,secao,vmax,mult_fcd);%Concreto kN e kN*m
    [Nap,Map] = Nap_Map(ap,EpA,xa,Epap,vmax,Es,fyd);%Aço Passivo CA-50 kN e kN*m
    [Naa,Maa] = Naa_Maa(aa,ap,EpA,xa,Epap,vmax,fpyd,fptd,Eppu,Ep);%Aço Ativo CP-190 RB kN e kN*m
    
    SN=Nc+Nap+Naa-Nsd;
    SM=Mc+Map+Maa-Msd;
end

